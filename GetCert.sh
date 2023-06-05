 #!/bin/bash

# Prompt for domain
read -p "Enter the domain: " domain

# Prompt for action (default: get)
read -p "Do you want to renew or get a cert? (R/G, default: G): " action

if [[ "$action" == "R" || "$action" == "r" ]]; then
  # Prompt for email
  read -p "Enter your email: " email

  # Renew Cert
  docker-compose run --rm certbot renew --email $email
else
  # GET Cert (use --dry-run first) And disable all SSL from nginx-conf
  docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d $domain --dry-run

  # Prompt to confirm if the dry run went okay
  read -p "Did the dry run complete successfully? (yes/no): " dry_run_status

  if [[ "$dry_run_status" == "yes" || "$dry_run_status" == "y" ]]; then
    # Proceed with actual certificate acquisition
    docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d $domain
  else
    echo "Dry run did not complete successfully. Please check for any issues and try again."
  fi
fi
