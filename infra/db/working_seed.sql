-- Working seed data for Restaurant Ops Hub
-- Clear existing data
DELETE FROM acknowledgements;
DELETE FROM shifts;
DELETE FROM changes;
DELETE FROM reviews;
DELETE FROM inventory;
DELETE FROM menus;

-- Insert users if they don't exist
INSERT INTO users (user_id, name, email, role, created_at) VALUES
('user-001', 'Chef John', 'chef@restaurant.com', 'staff', NOW()),
('user-002', 'Manager Sarah', 'manager@restaurant.com', 'manager', NOW()),
('user-003', 'Sommelier Mike', 'sommelier@restaurant.com', 'staff', NOW())
ON CONFLICT (user_id) DO NOTHING;

-- Insert menu items
INSERT INTO menus (item_id, name, price, allergy_flags, active, created_at, updated_at) VALUES
('CHK-001', 'Grilled Chicken Breast', 1899, 'None', true, NOW(), NOW()),
('BEEF-001', 'Ribeye Steak', 3299, 'None', true, NOW(), NOW()),
('FISH-001', 'Salmon Fillet', 2499, 'Contains: Seafood', true, NOW(), NOW()),
('VEG-001', 'Veggie Burger', 1499, 'Contains: Gluten', true, NOW(), NOW()),
('PASTA-001', 'Spaghetti Carbonara', 1799, 'Contains: Dairy, Gluten, Eggs', true, NOW(), NOW());

-- Insert inventory items
INSERT INTO inventory (item_id, status, notes, expected_back) VALUES
('CHK-001', 'EIGHTY_SIX', 'Supplier delivery delayed - out of chicken', '2024-01-20'),
('BEEF-001', 'EIGHTY_SIX', 'Ribeye steaks sold out - waiting for fresh delivery', '2024-01-19'),
('FISH-001', 'LOW', 'Running low on salmon', NULL),
('VEG-001', 'OK', '', NULL),
('PASTA-001', 'LOW', 'Carbonara sauce almost gone', NULL);

-- Insert recent reviews
INSERT INTO reviews (review_id, source, rating, text, created_at, theme, url) VALUES
('REV-001', 'Google', 5, 'Amazing food and excellent service! The ribeye steak was cooked perfectly.', '2025-09-18 19:30:00', 'Food Quality', 'https://maps.google.com/review1'),
('REV-002', 'Google', 4, 'Great atmosphere and good food. The chicken parmesan was delicious.', '2025-09-15 20:15:00', 'Value', 'https://maps.google.com/review2'),
('REV-003', 'Yelp', 5, 'Best restaurant in town! The salmon was fresh and the service was outstanding.', '2025-09-13 18:45:00', 'Service', 'https://yelp.com/review1'),
('REV-004', 'Yelp', 3, 'Food was okay but service was slow. Had to wait 45 minutes for our order.', '2025-09-10 21:00:00', 'Service', 'https://yelp.com/review2'),
('REV-005', 'TripAdvisor', 4, 'Great restaurant with excellent food. The wine selection was impressive.', '2025-09-16 19:30:00', 'Food Quality', 'https://tripadvisor.com/review1');

-- Insert changes
INSERT INTO changes (change_id, title, detail, effective_from, created_by, is_active, created_at) VALUES
('CHG-001', 'New Winter Menu Items', 'Added 5 new seasonal dishes including winter squash risotto.', '2025-09-17', 'user-001', true, '2025-09-17'),
('CHG-002', 'Price Update - Beef Items', 'Ribeye steak price increased by $2 due to supplier cost increase.', '2025-09-13', 'user-002', true, '2025-09-13'),
('CHG-003', 'Wine List Update', 'Added 12 new wines to our selection, including 6 reds and 6 whites.', '2025-09-15', 'user-003', true, '2025-09-15'),
('CHG-004', 'Kitchen Hours Change', 'Kitchen now closes at 10:30 PM on weekdays and 11:00 PM on weekends.', '2025-09-06', 'user-002', true, '2025-09-06'),
('CHG-005', 'New Staff Member', 'Welcome Sarah Johnson as our new sous chef!', '2025-09-13', 'user-001', true, '2025-09-13');
