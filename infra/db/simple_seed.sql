-- Simple seed data for Restaurant Ops Hub with recent dates
-- This uses existing users and matches the actual database schema

-- Clear existing data (in reverse order of dependencies)
DELETE FROM acknowledgements;
DELETE FROM shifts;
DELETE FROM changes;
DELETE FROM reviews;
DELETE FROM inventory;
DELETE FROM menus;

-- Insert comprehensive menu items (matching actual schema)
INSERT INTO menus (item_id, name, price, allergy_flags, active, created_at, updated_at) VALUES
-- Appetizers
('APP-001', 'Crispy Calamari', 1499, 'Contains: Seafood', true, NOW(), NOW()),
('APP-002', 'Buffalo Wings', 1299, 'Contains: Dairy', true, NOW(), NOW()),
('APP-003', 'Mozzarella Sticks', 999, 'Contains: Dairy, Gluten', true, NOW(), NOW()),
('APP-004', 'Bruschetta', 899, 'Contains: Gluten', true, NOW(), NOW()),
('APP-005', 'Chicken Quesadilla', 1199, 'Contains: Dairy, Gluten', true, NOW(), NOW());

-- Salads
('SAL-001', 'Caesar Salad', 1399, 'Contains: Dairy, Gluten', true, NOW(), NOW()),
('SAL-002', 'Garden Salad', 1099, 'None', true, NOW(), NOW()),
('SAL-003', 'Cobb Salad', 1599, 'Contains: Dairy, Eggs', true, NOW(), NOW()),
('SAL-004', 'Greek Salad', 1299, 'Contains: Dairy', true, NOW(), NOW());

-- Main Courses - Chicken
('CHK-001', 'Grilled Chicken Breast', 1899, 'None', true, NOW(), NOW()),
('CHK-002', 'Chicken Parmesan', 1999, 'Contains: Dairy, Gluten', true, NOW(), NOW()),
('CHK-003', 'Chicken Marsala', 2199, 'Contains: Dairy', true, NOW(), NOW()),
('CHK-004', 'BBQ Chicken', 1799, 'None', true, NOW(), NOW()),

-- Main Courses - Beef
('BEEF-001', 'Ribeye Steak', 3299, 'None', true, NOW(), NOW()),
('BEEF-002', 'Beef Burger', 1699, 'Contains: Gluten', true, NOW(), NOW()),
('BEEF-003', 'Beef Stir Fry', 1899, 'Contains: Soy', true, NOW(), NOW()),
('BEEF-004', 'Beef Tacos', 1499, 'Contains: Gluten', true, NOW(), NOW()),

-- Main Courses - Seafood
('FISH-001', 'Salmon Fillet', 2499, 'Contains: Seafood', true, NOW(), NOW()),
('FISH-002', 'Fish and Chips', 1599, 'Contains: Seafood, Gluten', true, NOW(), NOW()),
('FISH-003', 'Shrimp Scampi', 2299, 'Contains: Seafood, Dairy', true, NOW(), NOW()),
('FISH-004', 'Crab Cakes', 1999, 'Contains: Seafood, Eggs', true, NOW(), NOW()),

-- Vegetarian
('VEG-001', 'Veggie Burger', 1499, 'Contains: Gluten', true, NOW(), NOW()),
('VEG-002', 'Mushroom Risotto', 1799, 'Contains: Dairy', true, NOW(), NOW()),
('VEG-003', 'Vegetable Stir Fry', 1599, 'Contains: Soy', true, NOW(), NOW()),
('VEG-004', 'Quinoa Bowl', 1399, 'None', true, NOW(), NOW()),

-- Pasta
('PASTA-001', 'Spaghetti Carbonara', 1799, 'Contains: Dairy, Gluten, Eggs', true, NOW(), NOW()),
('PASTA-002', 'Fettuccine Alfredo', 1699, 'Contains: Dairy, Gluten', true, NOW(), NOW()),
('PASTA-003', 'Penne Arrabbiata', 1599, 'Contains: Gluten', true, NOW(), NOW()),
('PASTA-004', 'Lobster Ravioli', 2499, 'Contains: Seafood, Dairy, Gluten, Eggs', true, NOW(), NOW()),

-- Desserts
('DESS-001', 'Tiramisu', 899, 'Contains: Dairy, Eggs, Gluten', true, NOW(), NOW()),
('DESS-002', 'Chocolate Lava Cake', 999, 'Contains: Dairy, Eggs, Gluten', true, NOW(), NOW()),
('DESS-003', 'Cheesecake', 799, 'Contains: Dairy, Eggs, Gluten', true, NOW(), NOW()),
('DESS-004', 'Ice Cream Sundae', 699, 'Contains: Dairy', true, NOW(), NOW()),

-- Beverages
('BEV-001', 'House Wine (Glass)', 899, 'Contains: Sulfites', true, NOW(), NOW()),
('BEV-002', 'Craft Beer', 699, 'Contains: Gluten', true, NOW(), NOW()),
('BEV-003', 'Fresh Lemonade', 399, 'None', true, NOW(), NOW()),
('BEV-004', 'Coffee', 299, 'None', true, NOW(), NOW());

-- Insert inventory items with various stock statuses
INSERT INTO inventory (item_id, status, notes, expected_back) VALUES
-- 86'd items (out of stock)
('CHK-001', '86', 'Supplier delivery delayed - out of chicken', '2024-01-20'),
('BEEF-001', '86', 'Ribeye steaks sold out - waiting for fresh delivery', '2024-01-19'),
('FISH-001', '86', 'Salmon quality issue - returned to supplier', '2024-01-21'),
('APP-001', '86', 'Calamari supplier issue - no delivery this week', '2024-01-22'),

-- Low stock items
('BEEF-002', 'low', 'Only 3 burgers left - need to prep more', NULL),
('SAL-001', 'low', 'Running low on romaine lettuce', NULL),
('PASTA-001', 'low', 'Carbonara sauce almost gone', NULL),
('VEG-001', 'low', 'Veggie patties running low', NULL),
('DESS-001', 'low', 'Tiramisu almost sold out', NULL),

-- OK stock items
('CHK-002', 'ok', '', NULL),
('CHK-003', 'ok', '', NULL),
('CHK-004', 'ok', '', NULL),
('BEEF-003', 'ok', '', NULL),
('BEEF-004', 'ok', '', NULL),
('FISH-002', 'ok', '', NULL),
('FISH-003', 'ok', '', NULL),
('FISH-004', 'ok', '', NULL),
('VEG-002', 'ok', '', NULL),
('VEG-003', 'ok', '', NULL),
('VEG-004', 'ok', '', NULL),
('PASTA-002', 'ok', '', NULL),
('PASTA-003', 'ok', '', NULL),
('PASTA-004', 'ok', '', NULL),
('DESS-002', 'ok', '', NULL),
('DESS-003', 'ok', '', NULL),
('DESS-004', 'ok', '', NULL),
('BEV-001', 'ok', '', NULL),
('BEV-002', 'ok', '', NULL),
('BEV-003', 'ok', '', NULL),
('BEV-004', 'ok', '', NULL),
('APP-002', 'ok', '', NULL),
('APP-003', 'ok', '', NULL),
('APP-004', 'ok', '', NULL),
('APP-005', 'ok', '', NULL),
('SAL-002', 'ok', '', NULL),
('SAL-003', 'ok', '', NULL),
('SAL-004', 'ok', '', NULL);

-- Insert recent reviews (within last 30 days) - using specific dates
INSERT INTO reviews (review_id, source, rating, text, created_at, theme, url) VALUES
-- Google Reviews (recent)
('REV-001', 'Google', 5, 'Amazing food and excellent service! The ribeye steak was cooked perfectly and the staff was very attentive.', '2025-09-18 19:30:00', 'Food Quality', 'https://maps.google.com/review1'),
('REV-002', 'Google', 4, 'Great atmosphere and good food. The chicken parmesan was delicious, though a bit pricey.', '2025-09-15 20:15:00', 'Value', 'https://maps.google.com/review2'),
('REV-003', 'Google', 5, 'Best restaurant in town! The salmon was fresh and the service was outstanding. Will definitely come back.', '2025-09-13 18:45:00', 'Service', 'https://maps.google.com/review3'),
('REV-004', 'Google', 3, 'Food was okay but service was slow. Had to wait 45 minutes for our order.', '2025-09-10 21:00:00', 'Service', 'https://maps.google.com/review4'),
('REV-005', 'Google', 4, 'Nice place with good food. The pasta carbonara was excellent!', '2025-09-06 19:20:00', 'Food Quality', 'https://maps.google.com/review5'),

-- Yelp Reviews (recent)
('REV-006', 'Yelp', 5, 'Fantastic experience! The staff was friendly and the food was incredible. Highly recommend the lobster ravioli.', '2025-09-17 20:30:00', 'Food Quality', 'https://yelp.com/review1'),
('REV-007', 'Yelp', 4, 'Good food and reasonable prices. The veggie burger was surprisingly good!', '2025-09-14 18:15:00', 'Value', 'https://yelp.com/review2'),
('REV-008', 'Yelp', 2, 'Disappointed with the service. Food took forever and was cold when it arrived.', '2025-09-12 19:45:00', 'Service', 'https://yelp.com/review3'),
('REV-009', 'Yelp', 5, 'Outstanding! The chef really knows what they are doing. Every dish was perfect.', '2025-09-08 21:00:00', 'Food Quality', 'https://yelp.com/review4'),
('REV-010', 'Yelp', 3, 'Average food but nice ambiance. The dessert selection was limited.', '2025-09-05 20:00:00', 'Ambiance', 'https://yelp.com/review5'),

-- TripAdvisor Reviews (recent)
('REV-011', 'TripAdvisor', 4, 'Great restaurant with excellent food. The wine selection was impressive.', '2025-09-16 19:30:00', 'Food Quality', 'https://tripadvisor.com/review1'),
('REV-012', 'TripAdvisor', 5, 'Perfect for a romantic dinner. The atmosphere was lovely and the food was divine.', '2025-09-13 20:45:00', 'Ambiance', 'https://tripadvisor.com/review2'),
('REV-013', 'TripAdvisor', 3, 'Food was good but portions were small for the price. Service was average.', '2025-09-11 18:30:00', 'Value', 'https://tripadvisor.com/review3'),
('REV-014', 'TripAdvisor', 4, 'Nice place with good food. The staff was knowledgeable about the menu.', '2025-09-09 19:15:00', 'Service', 'https://tripadvisor.com/review4'),
('REV-015', 'TripAdvisor', 5, 'Excellent experience! The seafood was fresh and the presentation was beautiful.', '2025-09-07 21:00:00', 'Food Quality', 'https://tripadvisor.com/review5'),

-- Facebook Reviews (recent)
('REV-016', 'Facebook', 4, 'Good food and friendly staff. The atmosphere was cozy and welcoming.', '2025-09-19 18:30:00', 'Ambiance', 'https://facebook.com/review1'),
('REV-017', 'Facebook', 5, 'Amazing! The best restaurant in the area. Highly recommend!', '2025-09-17 19:45:00', 'Food Quality', 'https://facebook.com/review2'),
('REV-018', 'Facebook', 3, 'Decent food but overpriced. Service was okay.', '2025-09-14 20:15:00', 'Value', 'https://facebook.com/review3'),
('REV-019', 'Facebook', 4, 'Great place for a family dinner. Kids loved the pasta!', '2025-09-12 18:45:00', 'Family', 'https://facebook.com/review4'),
('REV-020', 'Facebook', 5, 'Outstanding service and delicious food. Will definitely return!', '2025-09-06 19:30:00', 'Service', 'https://facebook.com/review5'),

-- OpenTable Reviews (recent)
('REV-021', 'OpenTable', 4, 'Nice restaurant with good food. The reservation process was easy.', '2025-09-18 20:00:00', 'Service', 'https://opentable.com/review1'),
('REV-022', 'OpenTable', 5, 'Perfect evening! The food was exceptional and the service was top-notch.', '2025-09-15 19:30:00', 'Food Quality', 'https://opentable.com/review2'),
('REV-023', 'OpenTable', 3, 'Food was okay but the wait was too long. Not worth the price.', '2025-09-13 20:30:00', 'Value', 'https://opentable.com/review3'),
('REV-024', 'OpenTable', 4, 'Good experience overall. The wine pairing was excellent.', '2025-09-10 19:00:00', 'Food Quality', 'https://opentable.com/review4'),
('REV-025', 'OpenTable', 5, 'Fantastic! The chef really knows how to cook. Every bite was perfect.', '2025-09-04 21:15:00', 'Food Quality', 'https://opentable.com/review5');

-- Insert changes/announcements
INSERT INTO changes (change_id, title, detail, effective_from, created_by, is_active, created_at) VALUES
('CHG-001', 'New Winter Menu Items', 'Added 5 new seasonal dishes including winter squash risotto and braised short ribs. Available starting next week.', '2025-09-17', 'chef@restaurant.com', true, '2025-09-17'),
('CHG-002', 'Price Update - Beef Items', 'Ribeye steak price increased by $2 due to supplier cost increase. All other beef items remain the same.', '2025-09-13', 'manager@restaurant.com', true, '2025-09-13'),
('CHG-003', 'Wine List Update', 'Added 12 new wines to our selection, including 6 reds and 6 whites. Ask your server for recommendations.', '2025-09-15', 'sommelier@restaurant.com', true, '2025-09-15'),
('CHG-004', 'Kitchen Hours Change', 'Kitchen now closes at 10:30 PM on weekdays and 11:00 PM on weekends. Last seating 30 minutes before close.', '2025-09-06', 'manager@restaurant.com', true, '2025-09-06'),
('CHG-005', 'New Staff Member', 'Welcome Sarah Johnson as our new sous chef! She brings 8 years of experience from top restaurants.', '2025-09-13', 'chef@restaurant.com', true, '2025-09-13'),
('CHG-006', 'Delivery Service Launch', 'We now offer delivery within 5 miles! Order online or call us. Delivery fee is $3.99.', '2025-09-16', 'manager@restaurant.com', true, '2025-09-16'),
('CHG-007', 'Holiday Specials', 'Special holiday menu available December 20-31. Includes traditional favorites and new seasonal dishes.', '2025-09-14', 'chef@restaurant.com', true, '2025-09-14'),
('CHG-008', 'Reservation Policy Update', 'We now require credit card information for reservations of 6 or more people. No-show fee is $25 per person.', '2025-09-13', 'manager@restaurant.com', true, '2025-09-13'),
('CHG-009', 'New Happy Hour Menu', 'Extended happy hour from 4-7 PM with new appetizer specials and discounted drinks.', '2025-09-17', 'manager@restaurant.com', true, '2025-09-17'),
('CHG-010', 'Kitchen Renovation Complete', 'Our kitchen renovation is complete! New equipment means faster service and better food quality.', '2025-09-06', 'chef@restaurant.com', true, '2025-09-06'),
('CHG-011', 'Allergy Information Update', 'Updated allergy information for all menu items. Please inform your server of any allergies.', '2025-09-13', 'chef@restaurant.com', true, '2025-09-13'),
('CHG-012', 'New Payment Methods', 'We now accept Apple Pay, Google Pay, and contactless payments for faster checkout.', '2025-09-15', 'manager@restaurant.com', true, '2025-09-15');
