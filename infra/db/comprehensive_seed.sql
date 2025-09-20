-- Comprehensive seed data for Restaurant Ops Hub
-- This will populate the database with realistic data to showcase all features

-- Clear existing data (in reverse order of dependencies)
DELETE FROM acknowledgements;
DELETE FROM shifts;
DELETE FROM changes;
DELETE FROM reviews;
DELETE FROM inventory;
DELETE FROM menus;

-- Reset sequences
ALTER SEQUENCE menus_id_seq RESTART WITH 1;
ALTER SEQUENCE inventory_id_seq RESTART WITH 1;
ALTER SEQUENCE reviews_review_id_seq RESTART WITH 1;
ALTER SEQUENCE changes_change_id_seq RESTART WITH 1;
ALTER SEQUENCE shifts_shift_id_seq RESTART WITH 1;
ALTER SEQUENCE acknowledgements_ack_id_seq RESTART WITH 1;

-- Insert comprehensive menu items
INSERT INTO menus (item_id, name, category, price, description, is_available) VALUES
-- Appetizers
('APP-001', 'Crispy Calamari', 'Appetizers', 14.99, 'Fresh squid rings with marinara sauce', true),
('APP-002', 'Buffalo Wings', 'Appetizers', 12.99, 'Spicy chicken wings with blue cheese dip', true),
('APP-003', 'Mozzarella Sticks', 'Appetizers', 9.99, 'Golden fried mozzarella with marinara', true),
('APP-004', 'Bruschetta', 'Appetizers', 8.99, 'Toasted bread with tomatoes and basil', true),
('APP-005', 'Chicken Quesadilla', 'Appetizers', 11.99, 'Grilled chicken with cheese and peppers', true),

-- Salads
('SAL-001', 'Caesar Salad', 'Salads', 13.99, 'Romaine lettuce, croutons, parmesan, caesar dressing', true),
('SAL-002', 'Garden Salad', 'Salads', 10.99, 'Mixed greens, tomatoes, cucumbers, carrots', true),
('SAL-003', 'Cobb Salad', 'Salads', 15.99, 'Chicken, bacon, eggs, avocado, blue cheese', true),
('SAL-004', 'Greek Salad', 'Salads', 12.99, 'Feta, olives, tomatoes, cucumbers, red onion', true),

-- Main Courses - Chicken
('CHK-001', 'Grilled Chicken Breast', 'Main Courses', 18.99, 'Herb-marinated chicken with seasonal vegetables', true),
('CHK-002', 'Chicken Parmesan', 'Main Courses', 19.99, 'Breaded chicken with marinara and mozzarella', true),
('CHK-003', 'Chicken Marsala', 'Main Courses', 21.99, 'Chicken in marsala wine sauce with mushrooms', true),
('CHK-004', 'BBQ Chicken', 'Main Courses', 17.99, 'Smoked chicken with BBQ sauce', true),

-- Main Courses - Beef
('BEEF-001', 'Ribeye Steak', 'Main Courses', 32.99, '12oz ribeye with garlic mashed potatoes', true),
('BEEF-002', 'Beef Burger', 'Main Courses', 16.99, '8oz beef patty with lettuce, tomato, onion', true),
('BEEF-003', 'Beef Stir Fry', 'Main Courses', 18.99, 'Sliced beef with vegetables in teriyaki sauce', true),
('BEEF-004', 'Beef Tacos', 'Main Courses', 14.99, 'Three soft tacos with seasoned ground beef', true),

-- Main Courses - Seafood
('FISH-001', 'Salmon Fillet', 'Main Courses', 24.99, 'Atlantic salmon with lemon butter sauce', true),
('FISH-002', 'Fish and Chips', 'Main Courses', 15.99, 'Beer-battered cod with french fries', true),
('FISH-003', 'Shrimp Scampi', 'Main Courses', 22.99, 'Jumbo shrimp in garlic white wine sauce', true),
('FISH-004', 'Crab Cakes', 'Main Courses', 19.99, 'Two jumbo lump crab cakes with remoulade', true),

-- Vegetarian
('VEG-001', 'Veggie Burger', 'Vegetarian', 14.99, 'Plant-based patty with avocado and sprouts', true),
('VEG-002', 'Mushroom Risotto', 'Vegetarian', 17.99, 'Creamy arborio rice with wild mushrooms', true),
('VEG-003', 'Vegetable Stir Fry', 'Vegetarian', 15.99, 'Mixed vegetables in ginger soy sauce', true),
('VEG-004', 'Quinoa Bowl', 'Vegetarian', 13.99, 'Quinoa with roasted vegetables and tahini', true),

-- Pasta
('PASTA-001', 'Spaghetti Carbonara', 'Pasta', 16.99, 'Pasta with eggs, cheese, and pancetta', true),
('PASTA-002', 'Fettuccine Alfredo', 'Pasta', 15.99, 'Creamy alfredo sauce with fettuccine', true),
('PASTA-003', 'Penne Arrabbiata', 'Pasta', 14.99, 'Spicy tomato sauce with penne', true),
('PASTA-004', 'Lobster Ravioli', 'Pasta', 23.99, 'Homemade ravioli with lobster and cream sauce', true),

-- Desserts
('DESS-001', 'Chocolate Cake', 'Desserts', 7.99, 'Rich chocolate layer cake', true),
('DESS-002', 'Tiramisu', 'Desserts', 8.99, 'Classic Italian dessert with coffee and mascarpone', true),
('DESS-003', 'Cheesecake', 'Desserts', 7.99, 'New York style cheesecake with berry compote', true),
('DESS-004', 'Ice Cream Sundae', 'Desserts', 6.99, 'Three scoops with chocolate sauce and nuts', true),

-- Beverages
('BEV-001', 'Craft Beer', 'Beverages', 6.99, 'Local craft beer selection', true),
('BEV-002', 'House Wine', 'Beverages', 8.99, 'Red or white wine by the glass', true),
('BEV-003', 'Fresh Lemonade', 'Beverages', 4.99, 'Freshly squeezed lemonade', true),
('BEV-004', 'Coffee', 'Beverages', 2.99, 'Freshly brewed coffee', true);

-- Insert comprehensive inventory data
INSERT INTO inventory (item_id, status, notes, expected_back) VALUES
-- 86'd items (out of stock)
('CHK-001', '86', 'Supplier delivery delayed - out of chicken', '2024-01-20'),
('BEEF-001', '86', 'Ribeye steaks sold out - waiting for fresh delivery', '2024-01-19'),
('FISH-001', '86', 'Salmon quality issue - returned to supplier', '2024-01-21'),
('DESS-001', '86', 'Chocolate cake ingredients missing', '2024-01-18'),

-- Low stock items
('CHK-002', 'low', 'Only 3 portions left - need to prep more', NULL),
('BEEF-002', 'low', '2 burger patties remaining', NULL),
('FISH-002', 'low', 'Last batch of cod - order more', NULL),
('VEG-001', 'low', 'Running low on veggie patties', NULL),
('PASTA-001', 'low', 'Carbonara ingredients almost gone', NULL),
('SAL-001', 'low', 'Romaine lettuce running low', NULL),
('APP-001', 'low', 'Calamari supply dwindling', NULL),
('BEV-001', 'low', 'Craft beer selection limited', NULL),

-- OK items
('CHK-003', 'ok', 'Good stock levels', NULL),
('CHK-004', 'ok', 'Well stocked', NULL),
('BEEF-003', 'ok', 'Plenty available', NULL),
('BEEF-004', 'ok', 'Good supply', NULL),
('FISH-003', 'ok', 'Fresh shrimp in stock', NULL),
('FISH-004', 'ok', 'Crab cakes ready', NULL),
('VEG-002', 'ok', 'Mushroom risotto ingredients ready', NULL),
('VEG-003', 'ok', 'Vegetable stir fry well stocked', NULL),
('VEG-004', 'ok', 'Quinoa bowl ingredients available', NULL),
('PASTA-002', 'ok', 'Alfredo ingredients ready', NULL),
('PASTA-003', 'ok', 'Arrabbiata sauce prepared', NULL),
('PASTA-004', 'ok', 'Lobster ravioli in stock', NULL),
('DESS-002', 'ok', 'Tiramisu ready to serve', NULL),
('DESS-003', 'ok', 'Cheesecake available', NULL),
('DESS-004', 'ok', 'Ice cream sundae ingredients ready', NULL),
('BEV-002', 'ok', 'Wine selection good', NULL),
('BEV-003', 'ok', 'Lemonade ingredients fresh', NULL),
('BEV-004', 'ok', 'Coffee beans stocked', NULL),
('SAL-002', 'ok', 'Garden salad ingredients fresh', NULL),
('SAL-003', 'ok', 'Cobb salad components ready', NULL),
('SAL-004', 'ok', 'Greek salad ingredients available', NULL),
('APP-002', 'ok', 'Buffalo wings ready', NULL),
('APP-003', 'ok', 'Mozzarella sticks prepared', NULL),
('APP-004', 'ok', 'Bruschetta ingredients fresh', NULL),
('APP-005', 'ok', 'Chicken quesadilla ready', NULL);

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

-- Insert comprehensive changes data
INSERT INTO changes (change_id, title, detail, effective_from, created_by, is_active, created_at) VALUES
-- Menu Changes
('CHG-001', 'New Winter Menu Items', 'Added 5 new seasonal dishes including roasted butternut squash risotto and braised short ribs. All items are now available for ordering.', '2024-01-15 00:00:00', 'Chef Sarah', true, '2024-01-14 16:30:00'),
('CHG-002', 'Price Update - Beef Items', 'Ribeye steak price increased to $32.99 due to supplier cost increases. All other beef items remain the same price.', '2024-01-10 00:00:00', 'Manager Mike', true, '2024-01-09 14:20:00'),
('CHG-003', 'Wine List Update', 'Added 3 new wines to our selection: Pinot Noir from Oregon, Chardonnay from Napa Valley, and a local craft beer. Ask your server for recommendations.', '2024-01-12 00:00:00', 'Sommelier Lisa', true, '2024-01-11 11:45:00'),

-- Operational Changes
('CHG-004', 'Kitchen Hours Extended', 'Kitchen now stays open until 10:30 PM on weekends (Friday-Sunday) to accommodate late diners. Last seating at 10:00 PM.', '2024-01-08 00:00:00', 'Manager Mike', true, '2024-01-07 15:00:00'),
('CHG-005', 'New POS System Training', 'All staff must complete the new POS system training by January 20th. Training sessions are scheduled for this week. Contact HR for scheduling.', '2024-01-05 00:00:00', 'HR Director', true, '2024-01-04 09:00:00'),
('CHG-006', 'Delivery Service Partnership', 'We now offer delivery through DoorDash and Uber Eats. Delivery hours are 11 AM - 9 PM daily. Minimum order $25.', '2024-01-03 00:00:00', 'Manager Mike', true, '2024-01-02 12:30:00'),

-- Staff Changes
('CHG-007', 'New Head Chef Announcement', 'Please welcome our new Head Chef, Maria Rodriguez, who joined us this week. She brings 15 years of experience from top restaurants in New York.', '2024-01-01 00:00:00', 'Owner John', true, '2023-12-31 17:00:00'),
('CHG-008', 'Server Training Program', 'New server training program starts next Monday. All new hires must complete the 2-week program before serving customers independently.', '2023-12-28 00:00:00', 'Training Manager', true, '2023-12-27 10:00:00'),

-- Equipment/System Changes
('CHG-009', 'New Coffee Machine Installation', 'New espresso machine installed in the bar area. All baristas have been trained on the new equipment. Coffee quality should be significantly improved.', '2024-01-06 00:00:00', 'Bar Manager Tom', true, '2024-01-05 14:15:00'),
('CHG-010', 'Kitchen Equipment Maintenance', 'Scheduled maintenance for the main oven on January 18th from 2-4 PM. We will be using the backup oven during this time. No impact on service expected.', '2024-01-02 00:00:00', 'Kitchen Manager', true, '2024-01-01 08:00:00'),

-- Inactive changes (completed or cancelled)
('CHG-011', 'Holiday Special Menu', 'Holiday special menu was available from December 15-31. All special items have been removed from the menu.', '2023-12-15 00:00:00', 'Chef Sarah', false, '2023-12-14 16:00:00'),
('CHG-012', 'Staff Holiday Party', 'Annual staff holiday party scheduled for December 20th has been completed. Thank you to all staff for a great year!', '2023-12-20 00:00:00', 'HR Director', false, '2023-12-19 10:00:00');

-- Insert shift data
INSERT INTO shifts (shift_id, shift_date, shift_type, start_time, end_time, assigned_staff, notes) VALUES
('SHIFT-001', '2024-01-16', 'Morning', '08:00:00', '16:00:00', 'Sarah, Mike, Lisa', 'Prep for lunch rush, inventory check'),
('SHIFT-002', '2024-01-16', 'Evening', '16:00:00', '24:00:00', 'Maria, Tom, John', 'Dinner service, closing duties'),
('SHIFT-003', '2024-01-17', 'Morning', '08:00:00', '16:00:00', 'Sarah, Mike, Lisa', 'Regular morning prep'),
('SHIFT-004', '2024-01-17', 'Evening', '16:00:00', '24:00:00', 'Maria, Tom, John', 'Dinner service'),
('SHIFT-005', '2024-01-18', 'Morning', '08:00:00', '16:00:00', 'Sarah, Mike, Lisa', 'Weekend prep, special menu items'),
('SHIFT-006', '2024-01-18', 'Evening', '16:00:00', '24:00:00', 'Maria, Tom, John', 'Weekend dinner service'),
('SHIFT-007', '2024-01-19', 'Morning', '08:00:00', '16:00:00', 'Sarah, Mike, Lisa', 'Weekend brunch service'),
('SHIFT-008', '2024-01-19', 'Evening', '16:00:00', '24:00:00', 'Maria, Tom, John', 'Weekend dinner service');

-- Insert acknowledgement data
INSERT INTO acknowledgements (ack_id, change_id, user_id, acknowledged_at, notes) VALUES
('ACK-001', 'CHG-001', 'sarah_chef', '2024-01-14 17:00:00', 'New menu items prepared and ready'),
('ACK-002', 'CHG-002', 'mike_manager', '2024-01-09 15:00:00', 'Price updates implemented in POS system'),
('ACK-003', 'CHG-003', 'lisa_sommelier', '2024-01-11 12:00:00', 'Wine list updated and staff trained'),
('ACK-004', 'CHG-004', 'mike_manager', '2024-01-07 16:00:00', 'Extended hours posted and staff notified'),
('ACK-005', 'CHG-005', 'hr_director', '2024-01-04 10:00:00', 'Training schedule sent to all staff'),
('ACK-006', 'CHG-006', 'mike_manager', '2024-01-02 13:00:00', 'Delivery partnerships activated'),
('ACK-007', 'CHG-007', 'john_owner', '2023-12-31 18:00:00', 'New chef introduced to team'),
('ACK-008', 'CHG-008', 'training_manager', '2023-12-27 11:00:00', 'Training program materials prepared'),
('ACK-009', 'CHG-009', 'tom_bar', '2024-01-05 15:00:00', 'New coffee machine tested and working'),
('ACK-010', 'CHG-010', 'kitchen_manager', '2024-01-01 09:00:00', 'Maintenance scheduled with vendor');
