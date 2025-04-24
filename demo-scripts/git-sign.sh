#!/bin/bash

########################
# include the magic
########################
. demo-magic.sh

# cleaning git config 
git config --local --unset commit.gpgsign
git config --local --unset tag.gpgsign 
git config --local --unset gpg.x509.program 
git config --local --unset gpg.format 
git config --local --unset gitsign.fulcio 
git config --local --unset gitsign.rekor 
git config --local --unset gitsign.issuer 
git config --local --unset gitsign.clientID 
git config --local --unset user.name
git config --local --unset user.email

rm -rf ~/.sigstore/root

unset SIGSTORE_FULCIO_URL
unset SIGSTORE_OIDC_ISSUER
unset SIGSTORE_REKOR_URL

# setting the environment variables for RHTAS
export MY_SIGSTORE_OIDC_ISSUER=https://$(oc get route keycloak -n rhsso | tail -n 1 | awk '{print $2}')/auth/realms/openshift
export MY_SIGSTORE_FULCIO_URL=$(oc get fulcio -o jsonpath='{.items[0].status.url}' -n trusted-artifact-signer)
export MY_SIGSTORE_REKOR_URL=$(oc get rekor -o jsonpath='{.items[0].status.url}' -n trusted-artifact-signer)

clear

# Put your stuff here
p "Let's first show a standard git, without signing 
  ================================================"
p "Making some changes"

p "\n"

pei "echo \"Hello\" >> ~/rhtas-demo/my-app/index.html"

pe "git status"

pe "git commit -am \"Unsigned commit\""

wait

p "That looks good!"

clear

p "Let's show a signed commit with the public instance of sigstore
  ==============================================================="
p "Making again some changes"

pei "echo \"Another change\" >> ~/rhtas-demo/my-app/index.html"

p "And in order to tell git to sign the commit, we need to change the git config"

pe "git config --local commit.gpgsign true"
p "Let's give it a try!"

pe "git commit -am \"Try signing commit\""

wait

p "ok, it doesn't work that easily. We need to - first of all - tell git which program to use!"

pe "git config --local gpg.x509.program gitsign"
pe "git config --local gpg.format x509"

p "Let's try again"

pe "git commit -am \"Try signing commit again\""

wait

p "That has worked great. But overall, it doesn't feel right to have confidential information like e-mail adresses and the social login provider in a public ledger. Don't have something already running locally? Our private IDP?"

clear

p "Let's show git commit sign - exactly the same - but with sigstore running in our private infrastructure - either on-prem or in our private cloud"
p "==========================================================================================================="

p "The only thing we need to do is add some configuration properties to point to our private infrastructure"

pe "git config --local gitsign.fulcio $MY_SIGSTORE_FULCIO_URL"
pe "git config --local gitsign.rekor $MY_SIGSTORE_REKOR_URL"
pe "git config --local gitsign.issuer $MY_SIGSTORE_OIDC_ISSUER"
pe "git config --local gitsign.clientID trusted-artifact-signer"

p "Making again some changes"
pei "echo \"Another change\" >> ~/rhtas-demo/my-app/index.html"
 
pe "git commit -am \"Try signing commit, this time with our private infrastructure.\""

p "Wow, that's amazing!"

wait

clear

p "But actually, signing alone doesn't help anybody. We always have to verfiy at a certain point in time that the signature is valid AND has been performed by an authorized person."
p "================================================================================================================================================================================="

p "This is what \'gitsign verify\' does."

p "But let's first try to understand better what actually the payload of a signed commit is"

pe "git cat-file commit HEAD"

p "Just as a note: gitsign uses a slightly different (a so-called \"canonical\" format as the payload for the hash and the signature"

pe "The actual git commit SHA is: "

pe "git_commit_SHA=$(git rev-parse HEAD)"

pe "gitsign verify commit $gitcommit_SHA"

p "Great. This looks good. This command would typically be part of a deployment pipeline!"

wait

clear
