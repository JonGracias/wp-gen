CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON html.* TO 'Admin'@'localhost';
FLUSH PRIVILEGES;
