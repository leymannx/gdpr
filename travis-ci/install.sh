#!/usr/bin/env bash

# Debug.
{ echo "# DEBUG - PHP Mem limit" ; php -ini | grep memory_limit ; }
echo "# Preparing GIT repos"

# Remove the git details from our repo so we can treat it as a path.
cd ${TRAVIS_BUILD_DIR}
rm .git -rf

# Create our main Drupal project.
echo "# Creating Drupal project"
composer create-project drupal/drupal-recommended-project:${DRUPAL_CORE} ${DRUPAL_BUILD_ROOT}/drupal --stability dev --no-interaction
cd ${DRUPAL_BUILD_ROOT}/drupal

# Set our drupal core version.
composer require --dev --no-update drupal/coder wimg/php-compatibility jakub-onderka/php-parallel-lint jakub-onderka/php-console-highlighter

# Add our repositories for gdpr, as well as re-adding the Drupal package repo.
echo "# Configuring package repos"
composer config repositories.0 path ${TRAVIS_BUILD_DIR}

# Now require contacts which will pull itself from the paths.
echo "# Requiring gdpr"
composer require drupal/gdpr dev-master
