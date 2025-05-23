USE `app_db`;

-- 测试用户数据
INSERT IGNORE INTO `users` (`username`, `email`) VALUES
('admin', 'admin@example.com'),
('user1', 'user1@example.com');

-- 测试订单数据
INSERT IGNORE INTO `orders` (`user_id`, `amount`) VALUES
(1, 99.99),
(2, 50.00);