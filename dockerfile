# Utilisation de l'image officielle PHP avec FPM
FROM php:8.1-fpm

# Installation des extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql

# Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir le répertoire de travail dans le conteneur
WORKDIR /var/www/html

# Copier le code du projet dans le container
COPY . /var/www/html

# Copier le fichier .env dans le container
# (Il est recommandé de ne pas inclure le .env dans le Dockerfile, à la place, utilisez des variables d'environnement ou montages de volumes lors de l'exécution)
COPY .env.example .env

# Installation des dépendances avec Composer # --no-dev --optimize-autoloader
RUN composer install 

# Définir les droits d'accès
RUN chown -R www-data:www-data /var/www/html && chmod -R 775 /var/www/html

# Exposer le port 8000 pour accéder à l'application Laravel via PHP-FPM
EXPOSE 8000


# Entrypoint pour démarrer Laravel
ENTRYPOINT ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
