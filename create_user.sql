CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'Admin'@'localhost';
FLUSH PRIVILEGES;
