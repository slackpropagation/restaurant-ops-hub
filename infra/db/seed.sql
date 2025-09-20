-- Seed data for Restaurant Ops Hub
-- This file is automatically executed when the PostgreSQL container starts

-- Insert sample users
INSERT INTO users (user_id, role, name, email, phone, is_active) VALUES
('user-1', 'manager', 'John Manager', 'john@restaurant.com', '+1-555-0101', true),
('user-2', 'staff', 'Sarah Server', 'sarah@restaurant.com', '+1-555-0102', true),
('user-3', 'staff', 'Mike Cook', 'mike@restaurant.com', '+1-555-0103', true),
('user-4', 'admin', 'Admin User', 'admin@restaurant.com', '+1-555-0100', true);

-- Insert sample menu items
INSERT INTO menus (item_id, name, price, allergy_flags, active) VALUES
('CHK-001', 'Grilled Chicken Breast', 1899, '["gluten-free"]', true),
('BEEF-001', 'Ribeye Steak', 3299, '[]', true),
('FISH-002', 'Salmon Fillet', 2499, '["fish"]', true),
('VEG-001', 'Asparagus', 899, '[]', true),
('PASTA-001', 'Lobster Ravioli', 2299, '["gluten", "dairy", "shellfish"]', true),
('SALAD-001', 'Caesar Salad', 1299, '["dairy", "gluten"]', true),
('BURGER-001', 'Classic Burger', 1699, '["gluten", "dairy"]', true),
('VEGAN-001', 'Vegan Burger', 1599, '[]', true);

-- Insert sample inventory items
INSERT INTO inventory (item_id, status, notes, expected_back) VALUES
('CHK-001', '86', 'Out of stock - supplier issue', '2024-01-16'),
('BEEF-001', 'low', 'Only 2 portions left', NULL),
('FISH-002', 'ok', '', NULL),
('VEG-001', 'low', 'Running low on asparagus', NULL),
('PASTA-001', 'ok', '', NULL),
('SALAD-001', 'ok', '', NULL),
('BURGER-001', 'ok', '', NULL),
('VEGAN-001', 'ok', '', NULL);

-- Insert sample reviews
INSERT INTO reviews (review_id, source, rating, text, theme, created_at) VALUES
('rev-1', 'Google', 5, 'Excellent food and service! The staff was very friendly and the food came out quickly.', 'positive', '2024-01-15 10:00:00'),
('rev-2', 'Google', 3, 'Food was okay but service was slow. Had to wait 45 minutes for our order.', 'service', '2024-01-15 08:00:00'),
('rev-3', 'Yelp', 4, 'Great atmosphere and good food. Will definitely come back!', 'positive', '2024-01-14 15:30:00'),
('rev-4', 'Google', 2, 'Food was cold when it arrived. Not worth the price.', 'food_quality', '2024-01-14 12:00:00'),
('rev-5', 'Google', 5, 'Amazing experience! The ribeye steak was perfectly cooked.', 'positive', '2024-01-13 19:00:00'),
('rev-6', 'Yelp', 4, 'Good food but the restaurant was very loud.', 'atmosphere', '2024-01-13 18:30:00'),
('rev-7', 'Google', 1, 'Terrible service. Waiter was rude and forgot our order.', 'service', '2024-01-12 20:00:00'),
('rev-8', 'Google', 5, 'Best restaurant in town! Everything was perfect.', 'positive', '2024-01-12 14:00:00');

-- Insert sample changes/announcements
INSERT INTO changes (change_id, title, detail, created_by, is_active, created_at) VALUES
('change-1', 'New Menu Item Added', 'Added vegan burger to the menu. Available starting today. Please inform customers about the new option.', 'user-1', true, '2024-01-15 09:00:00'),
('change-2', 'Kitchen Hours Updated', 'Kitchen now closes at 10 PM on weekdays and 11 PM on weekends. Please update your schedules accordingly.', 'user-1', true, '2024-01-15 07:00:00'),
('change-3', 'Staff Meeting Schedule', 'Weekly staff meeting moved to Tuesday at 2 PM. Please mark your calendars.', 'user-1', false, '2024-01-14 16:00:00'),
('change-4', 'New POS System Training', 'Training session for the new POS system will be held tomorrow at 3 PM. All staff must attend.', 'user-1', true, '2024-01-14 14:00:00'),
('change-5', 'Holiday Schedule', 'Restaurant will be closed on January 20th for staff appreciation day.', 'user-1', true, '2024-01-13 10:00:00');

-- Insert sample shifts
INSERT INTO shifts (shift_id, starts, ends, role, employee, section) VALUES
('shift-1', '2024-01-15 09:00:00', '2024-01-15 17:00:00', 'manager', 'user-1', 'all'),
('shift-2', '2024-01-15 11:00:00', '2024-01-15 19:00:00', 'server', 'user-2', 'dining_room'),
('shift-3', '2024-01-15 10:00:00', '2024-01-15 18:00:00', 'cook', 'user-3', 'kitchen'),
('shift-4', '2024-01-16 09:00:00', '2024-01-16 17:00:00', 'manager', 'user-1', 'all'),
('shift-5', '2024-01-16 11:00:00', '2024-01-16 19:00:00', 'server', 'user-2', 'dining_room');

-- Insert sample acknowledgements
INSERT INTO acknowledgements (ack_id, user_id, change_id, acknowledged_at) VALUES
('ack-1', 'user-2', 'change-1', '2024-01-15 09:15:00'),
('ack-2', 'user-3', 'change-1', '2024-01-15 09:20:00'),
('ack-3', 'user-2', 'change-2', '2024-01-15 07:30:00'),
('ack-4', 'user-3', 'change-2', '2024-01-15 07:35:00'),
('ack-5', 'user-2', 'change-4', '2024-01-14 14:30:00'),
('ack-6', 'user-3', 'change-4', '2024-01-14 14:45:00');