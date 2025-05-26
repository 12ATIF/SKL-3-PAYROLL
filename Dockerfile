# Gunakan base image PHP dengan Apache
FROM php:8.4-apache

# Set working directory
WORKDIR /var/www/html

# Install ekstensi PHP yang dibutuhkan Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mbstring exif pcntl bcmath zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy konfigurasi Apache (jika ada kustomisasi)
# COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
# RUN a2enmod rewrite

# Copy file aplikasi
COPY . .

# Install dependensi Composer
RUN composer install --optimize-autoloader --no-dev

# Set permission
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port
EXPOSE 80

# Jalankan Apache
CMD ["apache2-foreground"]