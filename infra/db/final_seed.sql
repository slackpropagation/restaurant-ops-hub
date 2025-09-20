-- Final comprehensive seed data for Restaurant Ops Hub
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
('APP-005', 'Chicken Quesadilla', 1199, 'Contains: Dairy, Gluten', true, NOW(), NOW()),

-- Salads
('SAL-001', 'Caesar Salad', 1399, 'Contains: Dairy, Gluten', true, NOW(), NOW()),
('SAL-002', 'Garden Salad', 1099, 'None', true, NOW(), NOW()),
('SAL-003', 'Cobb Salad', 1599, 'Contains: Dairy, Eggs', true, NOW(), NOW()),
('SAL-004', 'Greek Salad', 1299, 'Contains: Dairy', true, NOW(), NOW()),

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
('PASTA-001', 'Spaghetti Carbonara', 1699, 'Contains: Dairy, Gluten, Eggs', true, NOW(), NOW()),
('PASTA-002', 'Fettuccine Alfredo', 1599, 'Contains: Dairy, Gluten', true, NOW(), NOW()),
('PASTA-003', 'Penne Arrabbiata', 1499, 'Contains: Gluten', true, NOW(), NOW()),
('PASTA-004', 'Lobster Ravioli', 2399, 'Contains: Seafood, Dairy, Gluten', true, NOW(), NOW()),

-- Desserts
('DESS-001', 'Chocolate Cake', 799, 'Contains: Dairy, Gluten, Eggs', true, NOW(), NOW()),
('DESS-002', 'Tiramisu', 899, 'Contains: Dairy, Gluten, Eggs', true, NOW(), NOW()),
('DESS-003', 'Cheesecake', 799, 'Contains: Dairy, Gluten, Eggs', true, NOW(), NOW()),
('DESS-004', 'Ice Cream Sundae', 699, 'Contains: Dairy', true, NOW(), NOW()),

-- Beverages
('BEV-001', 'Craft Beer', 699, 'Contains: Gluten', true, NOW(), NOW()),
('BEV-002', 'House Wine', 899, 'None', true, NOW(), NOW()),
('BEV-003', 'Fresh Lemonade', 499, 'None', true, NOW(), NOW()),
('BEV-004', 'Coffee', 299, 'None', true, NOW(), NOW());

-- Insert comprehensive inventory data (using correct enum values)
INSERT INTO inventory (item_id, status, notes, expected_back, updated_at) VALUES
-- 86'd items (out of stock)
('CHK-001', 'EIGHTY_SIX', 'Supplier delivery delayed - out of chicken', '2024-01-20', NOW()),
('BEEF-001', 'EIGHTY_SIX', 'Ribeye steaks sold out - waiting for fresh delivery', '2024-01-19', NOW()),
('FISH-001', 'EIGHTY_SIX', 'Salmon quality issue - returned to supplier', '2024-01-21', NOW()),
('DESS-001', 'EIGHTY_SIX', 'Chocolate cake ingredients missing', '2024-01-18', NOW()),

-- Low stock items
('CHK-002', 'LOW', 'Only 3 portions left - need to prep more', NULL, NOW()),
('BEEF-002', 'LOW', '2 burger patties remaining', NULL, NOW()),
('FISH-002', 'LOW', 'Last batch of cod - order more', NULL, NOW()),
('VEG-001', 'LOW', 'Running low on veggie patties', NULL, NOW()),
('PASTA-001', 'LOW', 'Carbonara ingredients almost gone', NULL, NOW()),
('SAL-001', 'LOW', 'Romaine lettuce running low', NULL, NOW()),
('APP-001', 'LOW', 'Calamari supply dwindling', NULL, NOW()),
('BEV-001', 'LOW', 'Craft beer selection limited', NULL, NOW()),

-- OK items
('CHK-003', 'OK', 'Good stock levels', NULL, NOW()),
('CHK-004', 'OK', 'Well stocked', NULL, NOW()),
('BEEF-003', 'OK', 'Plenty available', NULL, NOW()),
('BEEF-004', 'OK', 'Good supply', NULL, NOW()),
('FISH-003', 'OK', 'Fresh shrimp in stock', NULL, NOW()),
('FISH-004', 'OK', 'Crab cakes ready', NULL, NOW()),
('VEG-002', 'OK', 'Mushroom risotto ingredients ready', NULL, NOW()),
('VEG-003', 'OK', 'Vegetable stir fry well stocked', NULL, NOW()),
('VEG-004', 'OK', 'Quinoa bowl ingredients available', NULL, NOW()),
('PASTA-002', 'OK', 'Alfredo ingredients ready', NULL, NOW()),
('PASTA-003', 'OK', 'Arrabbiata sauce prepared', NULL, NOW()),
('PASTA-004', 'OK', 'Lobster ravioli in stock', NULL, NOW()),
('DESS-002', 'OK', 'Tiramisu ready to serve', NULL, NOW()),
('DESS-003', 'OK', 'Cheesecake available', NULL, NOW()),
('DESS-004', 'OK', 'Ice cream sundae ingredients ready', NULL, NOW()),
('BEV-002', 'OK', 'Wine selection good', NULL, NOW()),
('BEV-003', 'OK', 'Lemonade ingredients fresh', NULL, NOW()),
('BEV-004', 'OK', 'Coffee beans stocked', NULL, NOW()),
('SAL-002', 'OK', 'Garden salad ingredients fresh', NULL, NOW()),
('SAL-003', 'OK', 'Cobb salad components ready', NULL, NOW()),
('SAL-004', 'OK', 'Greek salad ingredients available', NULL, NOW()),
('APP-002', 'OK', 'Buffalo wings ready', NULL, NOW()),
('APP-003', 'OK', 'Mozzarella sticks prepared', NULL, NOW()),
('APP-004', 'OK', 'Bruschetta ingredients fresh', NULL, NOW()),
('APP-005', 'OK', 'Chicken quesadilla ready', NULL, NOW());

-- Insert comprehensive reviews data
INSERT INTO reviews (review_id, source, rating, text, created_at, theme, url) VALUES
-- Google Reviews
('REV-001', 'Google', 5, 'Amazing food and excellent service! The ribeye steak was cooked perfectly and the staff was very attentive.', '2024-01-15 19:30:00', 'Food Quality', 'https://maps.google.com/review1'),
('REV-002', 'Google', 4, 'Great atmosphere and good food. The chicken parmesan was delicious, though a bit pricey.', '2024-01-14 20:15:00', 'Value', 'https://maps.google.com/review2'),
('REV-003', 'Google', 5, 'Best restaurant in town! The salmon was fresh and the service was outstanding. Will definitely come back.', '2024-01-13 18:45:00', 'Service', 'https://maps.google.com/review3'),
('REV-004', 'Google', 3, 'Food was okay but service was slow. Had to wait 45 minutes for our order.', '2024-01-12 21:00:00', 'Service', 'https://maps.google.com/review4'),
('REV-005', 'Google', 4, 'Nice place with good food. The pasta carbonara was excellent!', '2024-01-11 19:20:00', 'Food Quality', 'https://maps.google.com/review5'),

-- Yelp Reviews
('REV-006', 'Yelp', 5, 'Fantastic experience! The staff was friendly and the food was incredible. Highly recommend the lobster ravioli.', '2024-01-10 20:30:00', 'Food Quality', 'https://yelp.com/review1'),
('REV-007', 'Yelp', 4, 'Good food and reasonable prices. The veggie burger was surprisingly good!', '2024-01-09 18:15:00', 'Value', 'https://yelp.com/review2'),
('REV-008', 'Yelp', 2, 'Disappointed with the service. Food took forever and was cold when it arrived.', '2024-01-08 19:45:00', 'Service', 'https://yelp.com/review3'),
('REV-009', 'Yelp', 5, 'Outstanding! The chef really knows what they are doing. Every dish was perfect.', '2024-01-07 21:00:00', 'Food Quality', 'https://yelp.com/review4'),
('REV-010', 'Yelp', 3, 'Average food but nice ambiance. The dessert selection was limited.', '2024-01-06 20:00:00', 'Ambiance', 'https://yelp.com/review5'),

-- TripAdvisor Reviews
('REV-011', 'TripAdvisor', 4, 'Great restaurant with excellent food. The wine selection was impressive.', '2024-01-05 19:30:00', 'Food Quality', 'https://tripadvisor.com/review1'),
('REV-012', 'TripAdvisor', 5, 'Perfect for a romantic dinner. The atmosphere was lovely and the food was divine.', '2024-01-04 20:45:00', 'Ambiance', 'https://tripadvisor.com/review2'),
('REV-013', 'TripAdvisor', 3, 'Food was good but portions were small for the price. Service was average.', '2024-01-03 18:30:00', 'Value', 'https://tripadvisor.com/review3'),
('REV-014', 'TripAdvisor', 4, 'Nice place with good food. The staff was knowledgeable about the menu.', '2024-01-02 19:15:00', 'Service', 'https://tripadvisor.com/review4'),
('REV-015', 'TripAdvisor', 5, 'Exceptional dining experience! Every course was perfectly prepared.', '2024-01-01 21:30:00', 'Food Quality', 'https://tripadvisor.com/review5'),

-- Facebook Reviews
('REV-016', 'Facebook', 4, 'Good food and friendly staff. The calamari appetizer was excellent!', '2023-12-31 20:00:00', 'Food Quality', 'https://facebook.com/review1'),
('REV-017', 'Facebook', 3, 'Decent food but the restaurant was very noisy. Hard to have a conversation.', '2023-12-30 19:45:00', 'Ambiance', 'https://facebook.com/review2'),
('REV-018', 'Facebook', 5, 'Amazing! The chef came out to check on us. Great attention to detail.', '2023-12-29 21:15:00', 'Service', 'https://facebook.com/review3'),
('REV-019', 'Facebook', 4, 'Good value for money. The portions were generous and the food was tasty.', '2023-12-28 18:30:00', 'Value', 'https://facebook.com/review4'),
('REV-020', 'Facebook', 2, 'Not impressed. The food was bland and the service was poor.', '2023-12-27 20:30:00', 'Service', 'https://facebook.com/review5'),

-- Recent reviews (last 7 days)
('REV-021', 'Google', 5, 'Just had dinner here and it was incredible! The new menu items are fantastic.', '2024-01-16 20:00:00', 'Food Quality', 'https://maps.google.com/review6'),
('REV-022', 'Yelp', 4, 'Great improvement in service. The staff was much more attentive tonight.', '2024-01-16 19:30:00', 'Service', 'https://yelp.com/review6'),
('REV-023', 'TripAdvisor', 5, 'Perfect evening! The wine pairing suggestions were spot on.', '2024-01-15 21:00:00', 'Service', 'https://tripadvisor.com/review6'),
('REV-024', 'Google', 3, 'Food was good but the restaurant was very busy and loud.', '2024-01-15 18:45:00', 'Ambiance', 'https://maps.google.com/review7'),
('REV-025', 'Yelp', 4, 'Nice place to celebrate. The dessert was the highlight of the meal.', '2024-01-14 20:30:00', 'Food Quality', 'https://yelp.com/review7');

-- Insert comprehensive changes data (using existing users)
INSERT INTO changes (change_id, title, detail, effective_from, created_by, is_active, created_at) VALUES
-- Menu Changes
('CHG-001', 'New Winter Menu Items', 'Added 5 new seasonal dishes including roasted butternut squash risotto and braised short ribs. All items are now available for ordering.', '2024-01-15 00:00:00', 'user-1', true, '2024-01-14 16:30:00'),
('CHG-002', 'Price Update - Beef Items', 'Ribeye steak price increased to $32.99 due to supplier cost increases. All other beef items remain the same price.', '2024-01-10 00:00:00', 'user-1', true, '2024-01-09 14:20:00'),
('CHG-003', 'Wine List Update', 'Added 3 new wines to our selection: Pinot Noir from Oregon, Chardonnay from Napa Valley, and a local craft beer. Ask your server for recommendations.', '2024-01-12 00:00:00', 'user-1', true, '2024-01-11 11:45:00'),

-- Operational Changes
('CHG-004', 'Kitchen Hours Extended', 'Kitchen now stays open until 10:30 PM on weekends (Friday-Sunday) to accommodate late diners. Last seating at 10:00 PM.', '2024-01-08 00:00:00', 'user-1', true, '2024-01-07 15:00:00'),
('CHG-005', 'New POS System Training', 'All staff must complete the new POS system training by January 20th. Training sessions are scheduled for this week. Contact HR for scheduling.', '2024-01-05 00:00:00', 'user-4', true, '2024-01-04 09:00:00'),
('CHG-006', 'Delivery Service Partnership', 'We now offer delivery through DoorDash and Uber Eats. Delivery hours are 11 AM - 9 PM daily. Minimum order $25.', '2024-01-03 00:00:00', 'user-1', true, '2024-01-02 12:30:00'),

-- Staff Changes
('CHG-007', 'New Head Chef Announcement', 'Please welcome our new Head Chef, Maria Rodriguez, who joined us this week. She brings 15 years of experience from top restaurants in New York.', '2024-01-01 00:00:00', 'user-4', true, '2023-12-31 17:00:00'),
('CHG-008', 'Server Training Program', 'New server training program starts next Monday. All new hires must complete the 2-week program before serving customers independently.', '2023-12-28 00:00:00', 'user-2', true, '2023-12-27 10:00:00'),

-- Equipment/System Changes
('CHG-009', 'New Coffee Machine Installation', 'New espresso machine installed in the bar area. All baristas have been trained on the new equipment. Coffee quality should be significantly improved.', '2024-01-06 00:00:00', 'user-3', true, '2024-01-05 14:15:00'),
('CHG-010', 'Kitchen Equipment Maintenance', 'Scheduled maintenance for the main oven on January 18th from 2-4 PM. We will be using the backup oven during this time. No impact on service expected.', '2024-01-02 00:00:00', 'user-3', true, '2024-01-01 08:00:00'),

-- Inactive changes (completed or cancelled)
('CHG-011', 'Holiday Special Menu', 'Holiday special menu was available from December 15-31. All special items have been removed from the menu.', '2023-12-15 00:00:00', 'user-1', false, '2023-12-14 16:00:00'),
('CHG-012', 'Staff Holiday Party', 'Annual staff holiday party scheduled for December 20th has been completed. Thank you to all staff for a great year!', '2023-12-20 00:00:00', 'user-4', false, '2023-12-19 10:00:00');
