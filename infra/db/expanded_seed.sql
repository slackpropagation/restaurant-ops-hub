-- Expanded seed data for Restaurant Ops Hub
-- 30 menu items, 10 inventory items, 50 reviews, 5 changes

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

-- Insert 30 menu items
INSERT INTO menus (item_id, name, price, allergy_flags, active, created_at, updated_at) VALUES
-- Appetizers (5 items)
('APP-001', 'Crispy Calamari', 1499, 'Contains: Seafood', true, NOW(), NOW()),
('APP-002', 'Buffalo Wings', 1299, 'Contains: Dairy', true, NOW(), NOW()),
('APP-003', 'Mozzarella Sticks', 999, 'Contains: Dairy, Gluten', true, NOW(), NOW()),
('APP-004', 'Bruschetta', 899, 'Contains: Gluten', true, NOW(), NOW()),
('APP-005', 'Chicken Quesadilla', 1199, 'Contains: Dairy, Gluten', true, NOW(), NOW()),

-- Salads (4 items)
('SAL-001', 'Caesar Salad', 1399, 'Contains: Dairy, Gluten', true, NOW(), NOW()),
('SAL-002', 'Garden Salad', 1099, 'None', true, NOW(), NOW()),
('SAL-003', 'Cobb Salad', 1599, 'Contains: Dairy, Eggs', true, NOW(), NOW()),
('SAL-004', 'Greek Salad', 1299, 'Contains: Dairy', true, NOW(), NOW()),

-- Main Courses - Chicken (4 items)
('CHK-001', 'Grilled Chicken Breast', 1899, 'None', true, NOW(), NOW()),
('CHK-002', 'Chicken Parmesan', 1999, 'Contains: Dairy, Gluten', true, NOW(), NOW()),
('CHK-003', 'Chicken Marsala', 2199, 'Contains: Dairy', true, NOW(), NOW()),
('CHK-004', 'BBQ Chicken', 1799, 'None', true, NOW(), NOW()),

-- Main Courses - Beef (4 items)
('BEEF-001', 'Ribeye Steak', 3299, 'None', true, NOW(), NOW()),
('BEEF-002', 'Beef Burger', 1699, 'Contains: Gluten', true, NOW(), NOW()),
('BEEF-003', 'Beef Stir Fry', 1899, 'Contains: Soy', true, NOW(), NOW()),
('BEEF-004', 'Beef Tacos', 1499, 'Contains: Gluten', true, NOW(), NOW()),

-- Main Courses - Seafood (4 items)
('FISH-001', 'Salmon Fillet', 2499, 'Contains: Seafood', true, NOW(), NOW()),
('FISH-002', 'Fish and Chips', 1599, 'Contains: Seafood, Gluten', true, NOW(), NOW()),
('FISH-003', 'Shrimp Scampi', 2299, 'Contains: Seafood, Dairy', true, NOW(), NOW()),
('FISH-004', 'Crab Cakes', 1999, 'Contains: Seafood, Eggs', true, NOW(), NOW()),

-- Vegetarian (4 items)
('VEG-001', 'Veggie Burger', 1499, 'Contains: Gluten', true, NOW(), NOW()),
('VEG-002', 'Mushroom Risotto', 1799, 'Contains: Dairy', true, NOW(), NOW()),
('VEG-003', 'Vegetable Stir Fry', 1599, 'Contains: Soy', true, NOW(), NOW()),
('VEG-004', 'Quinoa Bowl', 1399, 'None', true, NOW(), NOW()),

-- Pasta (4 items)
('PASTA-001', 'Spaghetti Carbonara', 1799, 'Contains: Dairy, Gluten, Eggs', true, NOW(), NOW()),
('PASTA-002', 'Fettuccine Alfredo', 1699, 'Contains: Dairy, Gluten', true, NOW(), NOW()),
('PASTA-003', 'Penne Arrabbiata', 1599, 'Contains: Gluten', true, NOW(), NOW()),
('PASTA-004', 'Lobster Ravioli', 2499, 'Contains: Seafood, Dairy, Gluten, Eggs', true, NOW(), NOW()),

-- Desserts (3 items)
('DESS-001', 'Tiramisu', 899, 'Contains: Dairy, Eggs, Gluten', true, NOW(), NOW()),
('DESS-002', 'Chocolate Lava Cake', 999, 'Contains: Dairy, Eggs, Gluten', true, NOW(), NOW()),
('DESS-003', 'Cheesecake', 799, 'Contains: Dairy, Eggs, Gluten', true, NOW(), NOW());

-- Insert 10 inventory items
INSERT INTO inventory (item_id, status, notes, expected_back) VALUES
-- 86'd items (3 items)
('CHK-001', 'EIGHTY_SIX', 'Supplier delivery delayed - out of chicken', '2024-01-20'),
('BEEF-001', 'EIGHTY_SIX', 'Ribeye steaks sold out - waiting for fresh delivery', '2024-01-19'),
('FISH-001', 'EIGHTY_SIX', 'Salmon quality issue - returned to supplier', '2024-01-21'),

-- Low stock items (4 items)
('BEEF-002', 'LOW', 'Only 3 burgers left - need to prep more', NULL),
('SAL-001', 'LOW', 'Running low on romaine lettuce', NULL),
('PASTA-001', 'LOW', 'Carbonara sauce almost gone', NULL),
('VEG-001', 'LOW', 'Veggie patties running low', NULL),

-- OK stock items (3 items)
('CHK-002', 'OK', '', NULL),
('FISH-002', 'OK', '', NULL),
('VEG-002', 'OK', '', NULL);

-- Insert 50 recent reviews
INSERT INTO reviews (review_id, source, rating, text, created_at, theme, url) VALUES
-- Google Reviews (15 reviews)
('REV-001', 'Google', 5, 'Amazing food and excellent service! The ribeye steak was cooked perfectly and the staff was very attentive.', '2025-09-18 19:30:00', 'Food Quality', 'https://maps.google.com/review1'),
('REV-002', 'Google', 4, 'Great atmosphere and good food. The chicken parmesan was delicious, though a bit pricey.', '2025-09-15 20:15:00', 'Value', 'https://maps.google.com/review2'),
('REV-003', 'Google', 5, 'Best restaurant in town! The salmon was fresh and the service was outstanding. Will definitely come back.', '2025-09-13 18:45:00', 'Service', 'https://maps.google.com/review3'),
('REV-004', 'Google', 3, 'Food was okay but service was slow. Had to wait 45 minutes for our order.', '2025-09-10 21:00:00', 'Service', 'https://maps.google.com/review4'),
('REV-005', 'Google', 4, 'Nice place with good food. The pasta carbonara was excellent!', '2025-09-06 19:20:00', 'Food Quality', 'https://maps.google.com/review5'),
('REV-006', 'Google', 5, 'Fantastic experience! The staff was friendly and the food was incredible. Highly recommend the lobster ravioli.', '2025-09-17 20:30:00', 'Food Quality', 'https://maps.google.com/review6'),
('REV-007', 'Google', 4, 'Good food and reasonable prices. The veggie burger was surprisingly good!', '2025-09-14 18:15:00', 'Value', 'https://maps.google.com/review7'),
('REV-008', 'Google', 2, 'Disappointed with the service. Food took forever and was cold when it arrived.', '2025-09-12 19:45:00', 'Service', 'https://maps.google.com/review8'),
('REV-009', 'Google', 5, 'Outstanding! The chef really knows what they are doing. Every dish was perfect.', '2025-09-08 21:00:00', 'Food Quality', 'https://maps.google.com/review9'),
('REV-010', 'Google', 3, 'Average food but nice ambiance. The dessert selection was limited.', '2025-09-05 20:00:00', 'Ambiance', 'https://maps.google.com/review10'),
('REV-011', 'Google', 4, 'Great restaurant with excellent food. The wine selection was impressive.', '2025-09-16 19:30:00', 'Food Quality', 'https://maps.google.com/review11'),
('REV-012', 'Google', 5, 'Perfect for a romantic dinner. The atmosphere was lovely and the food was divine.', '2025-09-13 20:45:00', 'Ambiance', 'https://maps.google.com/review12'),
('REV-013', 'Google', 3, 'Food was good but portions were small for the price. Service was average.', '2025-09-11 18:30:00', 'Value', 'https://maps.google.com/review13'),
('REV-014', 'Google', 4, 'Nice place with good food. The staff was knowledgeable about the menu.', '2025-09-09 19:15:00', 'Service', 'https://maps.google.com/review14'),
('REV-015', 'Google', 5, 'Excellent experience! The seafood was fresh and the presentation was beautiful.', '2025-09-07 21:00:00', 'Food Quality', 'https://maps.google.com/review15'),

-- Yelp Reviews (15 reviews)
('REV-016', 'Yelp', 4, 'Good food and friendly staff. The atmosphere was cozy and welcoming.', '2025-09-19 18:30:00', 'Ambiance', 'https://yelp.com/review1'),
('REV-017', 'Yelp', 5, 'Amazing! The best restaurant in the area. Highly recommend!', '2025-09-17 19:45:00', 'Food Quality', 'https://yelp.com/review2'),
('REV-018', 'Yelp', 3, 'Decent food but overpriced. Service was okay.', '2025-09-14 20:15:00', 'Value', 'https://yelp.com/review3'),
('REV-019', 'Yelp', 4, 'Great place for a family dinner. Kids loved the pasta!', '2025-09-12 18:45:00', 'Family', 'https://yelp.com/review4'),
('REV-020', 'Yelp', 5, 'Outstanding service and delicious food. Will definitely return!', '2025-09-06 19:30:00', 'Service', 'https://yelp.com/review5'),
('REV-021', 'Yelp', 4, 'Nice restaurant with good food. The reservation process was easy.', '2025-09-18 20:00:00', 'Service', 'https://yelp.com/review6'),
('REV-022', 'Yelp', 5, 'Perfect evening! The food was exceptional and the service was top-notch.', '2025-09-15 19:30:00', 'Food Quality', 'https://yelp.com/review7'),
('REV-023', 'Yelp', 3, 'Food was okay but the wait was too long. Not worth the price.', '2025-09-13 20:30:00', 'Value', 'https://yelp.com/review8'),
('REV-024', 'Yelp', 4, 'Good experience overall. The wine pairing was excellent.', '2025-09-10 19:00:00', 'Food Quality', 'https://yelp.com/review9'),
('REV-025', 'Yelp', 5, 'Fantastic! The chef really knows how to cook. Every bite was perfect.', '2025-09-04 21:15:00', 'Food Quality', 'https://yelp.com/review10'),
('REV-026', 'Yelp', 4, 'Great atmosphere and good food. The staff was very professional.', '2025-09-17 18:45:00', 'Service', 'https://yelp.com/review11'),
('REV-027', 'Yelp', 5, 'Best meal I have had in a long time. The presentation was beautiful!', '2025-09-14 20:00:00', 'Food Quality', 'https://yelp.com/review12'),
('REV-028', 'Yelp', 3, 'Food was decent but the service was slow. Had to ask for refills multiple times.', '2025-09-11 19:30:00', 'Service', 'https://yelp.com/review13'),
('REV-029', 'Yelp', 4, 'Nice place with good food. The portion sizes were generous.', '2025-09-08 18:15:00', 'Value', 'https://yelp.com/review14'),
('REV-030', 'Yelp', 5, 'Outstanding! The food was fresh and the service was impeccable.', '2025-09-05 20:45:00', 'Service', 'https://yelp.com/review15'),

-- TripAdvisor Reviews (10 reviews)
('REV-031', 'TripAdvisor', 4, 'Great restaurant with excellent food. The wine selection was impressive.', '2025-09-16 19:30:00', 'Food Quality', 'https://tripadvisor.com/review1'),
('REV-032', 'TripAdvisor', 5, 'Perfect for a romantic dinner. The atmosphere was lovely and the food was divine.', '2025-09-13 20:45:00', 'Ambiance', 'https://tripadvisor.com/review2'),
('REV-033', 'TripAdvisor', 3, 'Food was good but portions were small for the price. Service was average.', '2025-09-11 18:30:00', 'Value', 'https://tripadvisor.com/review3'),
('REV-034', 'TripAdvisor', 4, 'Nice place with good food. The staff was knowledgeable about the menu.', '2025-09-09 19:15:00', 'Service', 'https://tripadvisor.com/review4'),
('REV-035', 'TripAdvisor', 5, 'Excellent experience! The seafood was fresh and the presentation was beautiful.', '2025-09-07 21:00:00', 'Food Quality', 'https://tripadvisor.com/review5'),
('REV-036', 'TripAdvisor', 4, 'Good food and reasonable prices. The atmosphere was nice.', '2025-09-15 18:45:00', 'Value', 'https://tripadvisor.com/review6'),
('REV-037', 'TripAdvisor', 5, 'Amazing! The best restaurant in the area. Highly recommend!', '2025-09-12 19:30:00', 'Food Quality', 'https://tripadvisor.com/review7'),
('REV-038', 'TripAdvisor', 3, 'Decent food but overpriced. Service was okay.', '2025-09-09 20:15:00', 'Value', 'https://tripadvisor.com/review8'),
('REV-039', 'TripAdvisor', 4, 'Great place for a family dinner. Kids loved the pasta!', '2025-09-06 18:30:00', 'Family', 'https://tripadvisor.com/review9'),
('REV-040', 'TripAdvisor', 5, 'Outstanding service and delicious food. Will definitely return!', '2025-09-03 19:45:00', 'Service', 'https://tripadvisor.com/review10'),

-- Facebook Reviews (10 reviews)
('REV-041', 'Facebook', 4, 'Good food and friendly staff. The atmosphere was cozy and welcoming.', '2025-09-19 18:30:00', 'Ambiance', 'https://facebook.com/review1'),
('REV-042', 'Facebook', 5, 'Amazing! The best restaurant in the area. Highly recommend!', '2025-09-17 19:45:00', 'Food Quality', 'https://facebook.com/review2'),
('REV-043', 'Facebook', 3, 'Decent food but overpriced. Service was okay.', '2025-09-14 20:15:00', 'Value', 'https://facebook.com/review3'),
('REV-044', 'Facebook', 4, 'Great place for a family dinner. Kids loved the pasta!', '2025-09-12 18:45:00', 'Family', 'https://facebook.com/review4'),
('REV-045', 'Facebook', 5, 'Outstanding service and delicious food. Will definitely return!', '2025-09-06 19:30:00', 'Service', 'https://facebook.com/review5'),
('REV-046', 'Facebook', 4, 'Nice restaurant with good food. The reservation process was easy.', '2025-09-18 20:00:00', 'Service', 'https://facebook.com/review6'),
('REV-047', 'Facebook', 5, 'Perfect evening! The food was exceptional and the service was top-notch.', '2025-09-15 19:30:00', 'Food Quality', 'https://facebook.com/review7'),
('REV-048', 'Facebook', 3, 'Food was okay but the wait was too long. Not worth the price.', '2025-09-13 20:30:00', 'Value', 'https://facebook.com/review8'),
('REV-049', 'Facebook', 4, 'Good experience overall. The wine pairing was excellent.', '2025-09-10 19:00:00', 'Food Quality', 'https://facebook.com/review9'),
('REV-050', 'Facebook', 5, 'Fantastic! The chef really knows how to cook. Every bite was perfect.', '2025-09-04 21:15:00', 'Food Quality', 'https://facebook.com/review10');

-- Insert 5 changes/announcements
INSERT INTO changes (change_id, title, detail, effective_from, created_by, is_active, created_at) VALUES
('CHG-001', 'New Winter Menu Items', 'Added 5 new seasonal dishes including winter squash risotto and braised short ribs. Available starting next week.', '2025-09-17', 'user-001', true, '2025-09-17'),
('CHG-002', 'Price Update - Beef Items', 'Ribeye steak price increased by $2 due to supplier cost increase. All other beef items remain the same.', '2025-09-13', 'user-002', true, '2025-09-13'),
('CHG-003', 'Wine List Update', 'Added 12 new wines to our selection, including 6 reds and 6 whites. Ask your server for recommendations.', '2025-09-15', 'user-003', true, '2025-09-15'),
('CHG-004', 'Kitchen Hours Change', 'Kitchen now closes at 10:30 PM on weekdays and 11:00 PM on weekends. Last seating 30 minutes before close.', '2025-09-06', 'user-002', true, '2025-09-06'),
('CHG-005', 'New Staff Member', 'Welcome Sarah Johnson as our new sous chef! She brings 8 years of experience from top restaurants.', '2025-09-13', 'user-001', true, '2025-09-13');
