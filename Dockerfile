 
# Sử dụng PHP 8.1 với Apache
FROM php:8.1-apache

# Cài extension Laravel cần
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql zip

# Cài Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set thư mục làm việc
WORKDIR /var/www/html

# Copy source code vào container
COPY . .

# Cài dependency Laravel
RUN composer install --no-dev --optimize-autoloader

# Laravel cần quyền ghi cho storage & bootstrap/cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Mở port 80
EXPOSE 80

# Chạy Apache khi container start
CMD ["apache2-foreground"]
