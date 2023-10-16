#!/bin/bash

# Define a base URL for brevity in the git clone commands
BASE_URL="ssh://git@gitssh.portmm.net:2222/development"

git clone "$BASE_URL/my-ttb-main.git"                           # All
git clone "$BASE_URL/outbound-email-service-api.git"            # All
git clone "$BASE_URL/process-flow-service-api.git"              # MID, MAN
git clone "$BASE_URL/tax-ref-data-management-api.git"           # MAN
git clone "$BASE_URL/intake-data-management-api.git"            # MAN
git clone "$BASE_URL/im-data-management-api.git"                # MAN
git clone "$BASE_URL/idam-management-api.git"                  # MID
git clone "$BASE_URL/form-data-management-api.git"              # MAN
git clone "$BASE_URL/intake-token-service-api.git"              # MAN
git clone "$BASE_URL/foreign-producer-data-management-api.git"  # MAN
git clone "$BASE_URL/claims-management-service-api.git"         # MAN
git clone "$BASE_URL/my-ttb-authorization-api.git"              # All
git clone "$BASE_URL/mock-ponl-service-api.git"                 # MID
git clone "$BASE_URL/content-management-api.git"                # MAN, ROY
git clone "$BASE_URL/messaging-data-management-api.git"         # All
git clone "$BASE_URL/export-certificate-data-management-api.git" # ROY
git clone "$BASE_URL/itds-data-management-api.git"              # TEAL
git clone "$BASE_URL/banking-management-service-api.git"        # ROY, MAN

echo "Done cloning repositories."

