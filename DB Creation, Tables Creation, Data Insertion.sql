-- Database: marketplace

-- DROP DATABASE IF EXISTS marketplace;

CREATE DATABASE marketplace
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en-US'
    LC_CTYPE = 'en-US'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- -----------------------------------------------------
-- Tables (Relations)

CREATE TABLE Users (
    username VARCHAR PRIMARY KEY,
    name VARCHAR NOT NULL,
    family_name VARCHAR NOT NULL,
    gender VARCHAR CHECK (gender IN ('Male', 'Female', 'Other')),
    email VARCHAR UNIQUE NOT NULL,
    password VARCHAR NOT NULL,
    age INTEGER CHECK (age >= 0),
    phone_number VARCHAR
);

CREATE TABLE Addresses (
    id SERIAL PRIMARY KEY,
    user_username VARCHAR NOT NULL,
    address_text TEXT NOT NULL,
    postal_code VARCHAR,

    -- Foreign key constraint to ensure user exists in Users table
    CONSTRAINT fk_user_username
        FOREIGN KEY (user_username)
        REFERENCES Users(username)
        ON DELETE CASCADE
);

CREATE TABLE ShopOwners (
    username VARCHAR PRIMARY KEY,
    CONSTRAINT fk_shopowner_username
        FOREIGN KEY (username)
        REFERENCES Users(username)
        ON DELETE CASCADE
);

CREATE TABLE RegularUsers (
    username VARCHAR PRIMARY KEY,
    CONSTRAINT fk_regularuser_username
        FOREIGN KEY (username)
        REFERENCES Users(username)
        ON DELETE CASCADE
);

CREATE TABLE Messages (
    id SERIAL PRIMARY KEY,
    sender_username VARCHAR,
    receiver_username VARCHAR,
    message_text TEXT,
    sent_at TIMESTAMP,
    FOREIGN KEY (sender_username) REFERENCES Users(username),
    FOREIGN KEY (receiver_username) REFERENCES Users(username)
);

CREATE TABLE Shops (
    id SERIAL PRIMARY KEY,
    shop_identifier VARCHAR,
    rating FLOAT,
    sales_volume INT,
    owner_username VARCHAR,
    FOREIGN KEY (owner_username) REFERENCES Users(username)
);

CREATE TABLE Categories (
    id SERIAL PRIMARY KEY,
    title VARCHAR NOT NULL
);

CREATE TABLE ShopCategories (
    shop_id INT,
    category_id INT,
    PRIMARY KEY (shop_id, category_id),
    FOREIGN KEY (shop_id) REFERENCES Shops(id),
    FOREIGN KEY (category_id) REFERENCES Categories(id)
);

CREATE TABLE Products (
    id VARCHAR PRIMARY KEY,
    title VARCHAR NOT NULL,
    weight FLOAT,
    price FLOAT,
    stock_quantity INT,
    shipping_time VARCHAR,
    shipping_cost FLOAT,
    description TEXT
);

CREATE TABLE ShopProducts (
    shop_id INT,
    product_id VARCHAR,
    PRIMARY KEY (shop_id, product_id),
    FOREIGN KEY (shop_id) REFERENCES Shops(id),
    FOREIGN KEY (product_id) REFERENCES Products(id)
);

CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    user_username VARCHAR,
    total_price FLOAT,
    shipping_method VARCHAR,
    payment_method VARCHAR,
    payment_time TIMESTAMP,
    registration_time TIMESTAMP,
    status VARCHAR,
    tracking_code VARCHAR,
    buyer_note TEXT,
    buyer_review TEXT,
    FOREIGN KEY (user_username) REFERENCES Users(username)
);

CREATE TABLE OrderProducts (
    order_id INT,
    product_id VARCHAR,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (product_id) REFERENCES Products(id)
);

CREATE TABLE ProductReviews (
    id SERIAL PRIMARY KEY,
    user_username VARCHAR,
    product_id VARCHAR,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    review_date TIMESTAMP,
    FOREIGN KEY (user_username) REFERENCES Users(username),
    FOREIGN KEY (product_id) REFERENCES Products(id)
);

CREATE TABLE Admins (
    username VARCHAR,
    FOREIGN KEY (username) REFERENCES Users(username)
);

-- -----------------------------------------------------
-- Insert Data

INSERT INTO Users (username, name, family_name, gender, email, password, age, phone_number) VALUES
('davenportjessica', 'Keith', 'Moore', 'Male', 'amandaespinoza@example.com', 'MZQ1j)Mi!%', 34, '(705)945-2005'),
('sbarnes', 'Edward', 'Williams', 'Other', 'steinkaren@example.com', 'sYqaCrrQ^8', 65, '001-549-329-2539'),
('matthewpearson', 'Breanna', 'Harris', 'Other', 'michael79@example.net', 'czoTuQ#S)9', 29, '001-976-495-1508'),
('derek75', 'Maria', 'Sexton', 'Female', 'mosesroy@example.org', 'V9+8PTiuM$', 50, '001-566-313-8501x5285'),
('ipatrick', 'Lauren', 'Hebert', 'Female', 'jacquelinehouston@example.net', '%e9lKQIo52', 41, '(464)508-3690'),
('tlong', 'Michele', 'Copeland', 'Other', 'rosskatherine@example.com', '+31S#jKAs0', 53, '+1-357-738-4019'),
('dustinwilson', 'Sarah', 'Johnson', 'Male', 'rrodriguez@example.com', '$0aRF1mm68', 58, '744.690.9721'),
('justin45', 'Hannah', 'Porter', 'Female', 'jwilliams@example.org', 'Z!Z_8FZh!q', 43, '(528)764-3945'),
('joseph57', 'Angela', 'Haynes', 'Female', 'carolynwhite@example.org', 'd9gPMs+r&2', 20, '613-710-1837'),
('angelasmith', 'Deborah', 'Hampton', 'Female', 'marcus27@example.org', 'V8WQ!ZKz^h', 28, '+1-444-629-4618'),
('eriley', 'Susan', 'Riddle', 'Female', 'nicole76@example.org', 'a!5RVDlC$8', 34, '599-389-4978'),
('tjohnson', 'Christopher', 'Delacruz', 'Female', 'roywalker@example.org', '!X1Di9xb@5', 43, '714.611.5702x110'),
('hhawkins', 'Bryan', 'Clark', 'Male', 'tabbott@example.org', 'd)31fWn+Ec', 28, '(602)524-1719x10438'),
('david65', 'Brooke', 'Hopkins', 'Male', 'andersonvanessa@example.org', 'Z1R4^Kfv#L', 18, '8438219820'),
('brittany79', 'Nicole', 'Hale', 'Female', 'msanchez@example.org', '+4Q1ot5Mo$', 70, '(490)654-5017'),
('staceymiller', 'Anita', 'Figueroa', 'Male', 'berryandrew@example.org', 'baMD2p)o&9', 54, '001-735-780-8212'),
('brianna36', 'Thomas', 'Sanchez', 'Other', 'bryanpayne@example.org', 'IKmg@2LfN9', 47, '561.803.0079x945'),
('speterson', 'Nicole', 'Stanley', 'Other', 'mathewnorton@example.net', '!8J0rjnB_6', 53, '550.823.0075'),
('cookecolin', 'Rebecca', 'Collins', 'Male', 'millersteven@example.org', '_6L20O)m^+', 61, '496-976-5962x20792'),
('melissamitchell', 'Jennifer', 'Garrett', 'Male', 'deannalynch@example.net', '+c1u+Jphb&', 69, '(610)806-8731x71222'),
('ggutierrez', 'Abigail', 'Hernandez', 'Female', 'erica95@example.com', 'tr!Fw5cv_1', 19, '001-240-258-0819'),
('wallacejacob', 'Pamela', 'Roberts', 'Female', 'leesarah@example.org', 'R%_%4iYgy%', 28, '001-399-297-4646x422'),
('deborahgalloway', 'Jessica', 'Patel', 'Female', 'philipwhitaker@example.com', '*Zu5ZU3d)6', 63, '471-569-2930'),
('clopez', 'James', 'Wilson', 'Female', 'vincenthodges@example.org', '@XK7Opiv(L', 37, '800.294.5235x000'),
('qrodriguez', 'Harry', 'Garrett', 'Other', 'erikoliver@example.net', 'oFHT4rTO@0', 38, '001-616-326-4861x582'),
('chelsea28', 'Brian', 'Davis', 'Other', 'douglasbrittany@example.com', '&4E(PLO5sj', 60, '969-431-5018'),
('cnewton', 'Megan', 'Hodge', 'Female', 'greyes@example.com', 'f9&5YJk6GC', 64, '882.525.2159x923'),
('melissacoffey', 'Joseph', 'Jacobs', 'Other', 'heatherschroeder@example.com', ')M4FO7BqQf', 42, '(899)927-7296x7486'),
('melissamorris', 'Michael', 'Henry', 'Male', 'ypowell@example.net', '_6Y#dmvdp4', 35, '269-272-3974x1848'),
('rangelamy', 'Maxwell', 'Cherry', 'Other', 'dpollard@example.com', 'm5LS8Wtg)k', 63, '276.201.1897x757'),
('wsutton', 'Lori', 'Olson', 'Female', 'peterwilkins@example.com', 'D$6MvKDpPt', 66, '(870)674-4298'),
('colemanbrittany', 'Gregg', 'Barnes', 'Male', 'jillmeyer@example.com', 'm$T03BFme!', 68, '+1-890-690-3281x07296'),
('daniel34', 'Emily', 'Saunders', 'Female', 'uwarren@example.net', 'L99VwRwI)7', 34, '5676734546'),
('trocha', 'Michael', 'Mcfarland', 'Male', 'rodney87@example.com', '*)l47Vg!BJ', 23, '001-524-902-5083x6111'),
('burnsjessica', 'Daniel', 'Burton', 'Male', 'vincent21@example.com', '(3rV7&EEu$', 23, '(639)787-7645'),
('bsimmons', 'Casey', 'Garcia', 'Female', 'danny49@example.org', 'TrlB8Gpz*#', 47, '+1-312-414-7280x440'),
('ugonzalez', 'Randy', 'Horn', 'Male', 'shepherdjennifer@example.net', 'ASLWH@a4!6', 44, '+1-332-968-6109x57007'),
('leahandrade', 'Juan', 'Cole', 'Male', 'kelliott@example.com', '^cPP*Q4l2m', 19, '390-958-0623x886'),
('leerobert', 'Patrick', 'Parker', 'Other', 'loganlinda@example.net', '+fRRvSPx4p', 54, '930-712-7365x6921'),
('jonathanmorris', 'Lindsay', 'Lopez', 'Other', 'jamesmyers@example.net', 'v5NkDDJk(X', 59, '001-387-921-3993'),
('melindajackson', 'Audrey', 'Lang', 'Female', 'hross@example.net', '8)_Z2Gx%&y', 38, '+1-345-788-8673x0845'),
('richardsjanet', 'Lisa', 'Woods', 'Other', 'josephduncan@example.com', '%MEbAA1dX8', 25, '(362)769-3542x172'),
('moonlisa', 'Michelle', 'Peters', 'Male', 'hshah@example.org', 'E%X2WVyI@n', 69, '910.260.5316x28061'),
('xcrane', 'Megan', 'Becker', 'Female', 'alvarezrhonda@example.com', ')4j_VY6abv', 54, '001-388-959-0827x62534'),
('croberts', 'David', 'Jordan', 'Other', 'xtaylor@example.net', '4PDuENmh@G', 44, '385.381.2274'),
('teresa90', 'Roy', 'Wilson', 'Other', 'brett22@example.net', '_6tC#y2xD@', 30, '001-324-595-2500x08446'),
('snyderalexa', 'Nicole', 'Kelly', 'Other', 'sandralevine@example.com', '*z2adDBw9&', 44, '694-875-0515x571'),
('william68', 'Calvin', 'Roberts', 'Female', 'abates@example.org', 'b5n5MtOL@e', 29, '5215411671'),
('bpage', 'Michael', 'Williams', 'Female', 'laura74@example.org', 'dw5JKKw34_', 53, '+1-224-832-3725x73413'),
('rojasstephanie', 'Tyler', 'Day', 'Male', 'mcneileric@example.org', '67HY7EFn(k', 50, '+1-992-288-5993x79998'),
('daniel74', 'Joshua', 'Silva', 'Female', 'glamb@example.com', '5pA77HE_k%', 48, '+1-925-499-5970x3634'),
('macdonaldallison', 'Jessica', 'Martinez', 'Male', 'anthony72@example.org', '+^U9)fQss8', 64, '+1-428-443-4222'),
('fordthomas', 'David', 'Morales', 'Male', 'pmoore@example.org', 'wT94IIQx_(', 40, '357-408-9414x0924'),
('ariaskrystal', 'Dawn', 'Davis', 'Male', 'nhood@example.org', '@N0T^QOof)', 63, '001-379-634-8800x55337'),
('staceyoneill', 'Lindsey', 'White', 'Female', 'qshaffer@example.com', '__*L4Lr7wI', 20, '(379)366-2338x8239'),
('roneill', 'Rebecca', 'Gonzalez', 'Other', 'robertmccullough@example.net', '$0_XDpTJ*e', 32, '(242)671-4091x8245'),
('sphillips', 'Amanda', 'Thomas', 'Male', 'xferguson@example.org', '+81Frpu%mi', 21, '353-978-6755'),
('bensondavid', 'Rachel', 'Harris', 'Male', 'miranda16@example.org', 'I5X0bjgv_l', 47, '(469)597-3202'),
('arobinson', 'Jeremy', 'Dawson', 'Female', 'allisonelliott@example.net', '_(_9ZsEz*Y', 44, '831.493.2078x5249'),
('melissalester', 'Christian', 'Daniels', 'Male', 'larry01@example.com', '^1BdBzlp)D', 25, '+1-662-725-9126x2903'),
('mendozaannette', 'Alvin', 'Erickson', 'Male', 'ruiznatalie@example.org', 'D5&Zj1Ep!y', 67, '216-879-3241'),
('linjade', 'Danielle', 'Cunningham', 'Male', 'owilliams@example.net', 'Gt8%4NNM@(', 19, '001-386-549-7185'),
('ogibbs', 'Brian', 'Williams', 'Other', 'mark61@example.com', 'a(31Ex$*$4', 36, '353.351.8859'),
('robertsjulia', 'Jody', 'Gaines', 'Female', 'johnjones@example.net', '*JAi1jPos_', 19, '+1-531-532-0780'),
('bjohnson', 'Andre', 'Taylor', 'Female', 'angelamoody@example.net', '2Z)i4Vnh+X', 40, '990.535.3915x21587'),
('bauerchristopher', 'Audrey', 'Willis', 'Male', 'kimberly99@example.org', 'oP1FuIKg*(', 27, '899-561-4506'),
('ccalhoun', 'Robert', 'Santos', 'Female', 'njohnson@example.org', '^ONIcNu#6k', 53, '(377)222-9530'),
('sheamonica', 'Cynthia', 'Hoffman', 'Male', 'evansanthony@example.com', '^b)SfI9gh7', 58, '001-851-267-1361'),
('twilson', 'Lisa', 'Mcbride', 'Other', 'yparker@example.com', '^1JwJ!KW2k', 27, '+1-474-331-5026'),
('patrickharvey', 'Paul', 'Adams', 'Female', 'hendrixtina@example.net', 'gnV9AzV+@f', 65, '887.775.0545x7470'),
('grantjames', 'Janet', 'Jones', 'Male', 'adam78@example.net', '&(@8OimtFA', 35, '001-200-968-9075x943'),
('laura25', 'Tamara', 'Garcia', 'Other', 'ronnie93@example.net', 'uvO@E4QaIC', 50, '460.438.4498x415'),
('mnelson', 'Shelly', 'Greene', 'Other', 'adrian76@example.org', 'aDU77_Sl6)', 47, '7856478121'),
('hughesashley', 'Jeff', 'Garcia', 'Other', 'thayes@example.com', '_82hMNbxql', 48, '4168102208'),
('claudia27', 'Carrie', 'Alexander', 'Female', 'rjordan@example.net', '(dJW!s(RS5', 50, '939-940-7643'),
('mgriffin', 'Cindy', 'Stafford', 'Female', 'lopezjason@example.com', '%Jdd8$tlq4', 35, '385.437.6624'),
('wbaker', 'Michael', 'Hatfield', 'Male', 'meltonalbert@example.net', 'Q(n7eS#xDe', 68, '(688)255-4656x76303'),
('elizabethperry', 'Sophia', 'Campbell', 'Other', 'bhayes@example.org', '509xXs(f%C', 63, '+1-639-272-4151x8873'),
('jessewood', 'Samantha', 'Garcia', 'Female', 'austinsmith@example.org', '#OG3Sh*9Bq', 59, '321.995.3382'),
('egraham', 'John', 'Grimes', 'Female', 'johnsondavid@example.com', 'y6DToOY)_*', 65, '488-255-1127'),
('christy48', 'Sherri', 'Rodriguez', 'Other', 'markhernandez@example.org', '!5D+6lGSWV', 21, '367-539-1712'),
('jerry25', 'Laurie', 'Walker', 'Other', 'wwright@example.com', '+Ta6ZTjbF7', 46, '817-560-4019'),
('travis30', 'Kyle', 'Kelley', 'Male', 'davidbush@example.org', 'nVtCl@ff#4', 51, '001-559-962-5028x6818'),
('john73', 'Rachel', 'Page', 'Male', 'brownmolly@example.com', 'vS2u)X8e^9', 68, '001-527-264-9222x3550'),
('tammysmith', 'Kayla', 'Solomon', 'Other', 'probinson@example.org', '$iMufuCi*8', 25, '+1-743-673-8827x965'),
('friedmancindy', 'Sheryl', 'Decker', 'Female', 'staceyjohnson@example.org', 'C4$yRjda!q', 53, '(386)823-6103x302'),
('vgreen', 'Wanda', 'Yoder', 'Female', 'nbishop@example.com', ')0D6PRiBEe', 46, '361-926-1808x357'),
('erika75', 'Angela', 'Goodwin', 'Female', 'freemanjulia@example.org', 'fz4Yts%tk@', 39, '955.226.3286x915'),
('lucaschristine', 'Wendy', 'Gardner', 'Female', 'kimberlybrady@example.com', '@&M0@!snS2', 36, '(574)709-6820x469'),
('justin38', 'Michael', 'Kim', 'Other', 'ryan86@example.net', 'lhpW(9LyPA', 51, '648-297-2952'),
('zcrawford', 'Nicholas', 'Ryan', 'Female', 'washingtoncatherine@example.org', '0eQN2LwW^k', 57, '891-593-4896'),
('salazargregory', 'Sheryl', 'Pierce', 'Male', 'julia91@example.org', 'm_p*2Za6Jw', 37, '+1-271-588-9443x12872'),
('doris44', 'Shane', 'Bates', 'Other', 'allison18@example.com', '57LP6zdu!P', 39, '001-897-947-3578x10529'),
('danielle74', 'Jeffrey', 'Sanders', 'Male', 'patriciabell@example.net', '*3#29LVdkk', 23, '001-791-512-7543x36221'),
('caseykimberly', 'Kyle', 'Johnson', 'Male', 'iwilson@example.com', 'ec^6QooG4!', 44, '234.234.0062'),
('morrisonsara', 'Darryl', 'Patterson', 'Male', 'perkinssteven@example.org', '@y_DEkBrq0', 44, '239.689.7169'),
('vburns', 'Randall', 'Lopez', 'Female', 'deborahparrish@example.org', '&xE4DEHod4', 54, '985-378-4167x463'),
('svalenzuela', 'Austin', 'Oliver', 'Other', 'lori90@example.net', 'ru*5P#xPp2', 54, '(689)452-3343x400'),
('powersbryan', 'Michael', 'Scott', 'Female', 'vdudley@example.com', 'y536PPqjj+', 33, '404-979-9988'),
('colton14', 'Meghan', 'Yang', 'Female', 'paulmoreno@example.net', 'V^(1GQgB!T', 42, '001-748-543-7468x82181');

INSERT INTO Categories (id, title) VALUES
(1, 'light'),
(2, 'teach'),
(3, 'bit'),
(4, 'power'),
(5, 'democratic'),
(6, 'note'),
(7, 'particularly'),
(8, 'whole'),
(9, 'bit'),
(10, 'my');

INSERT INTO Products (id, title, weight, price, stock_quantity, shipping_time, shipping_cost, description) VALUES
('P1000', 'Crime', 2.16, 462.53, 44, '1 week', 11.03, 'Near face she. Sense dark technology station eight father. Go size allow foot little.'),
('P1001', 'Sometimes', 2.63, 13.16, 92, '1 week', 13.09, 'Realize foot seek sell eye. Late hit design central social water send.'),
('P1002', 'Whose', 4.95, 326.47, 95, '3-5 days', 2.49, 'Work TV low. Leader short happy want.'),
('P1003', 'Learn', 0.95, 233.75, 29, '3-5 days', 7.75, 'General view live note home town run. Political nature fall family him.'),
('P1004', 'Speak', 3.31, 108.21, 18, '2 days', 10.4, 'Picture culture morning value create student either. Land generation position resource ask.'),
('P1005', 'Share', 3.15, 186.27, 82, '1 week', 9.02, 'Nature school hard town. Stage development side white.'),
('P1006', 'Long', 2.08, 391.9, 20, '3-5 days', 12.08, 'Thought exactly tend each. Power field instead operation law administration. Green live page wish.'),
('P1007', 'Course', 3.85, 488.99, 33, '3-5 days', 7.04, 'Number president news tree husband scene cell. Kind north certain son.'),
('P1008', 'Rule', 1.07, 454.13, 86, '3-5 days', 9.93, 'Sing want small to actually. Trouble day raise team best.'),
('P1009', 'Record', 3.37, 385.48, 55, '2 days', 18.03, 'Face concern hair. Pay practice close until. Social some hand.'),
('P1010', 'Rule', 0.79, 496.69, 71, '1 week', 2.75, 'True in cost question suggest whom. Until green spring beat. Inside she staff available realize.'),
('P1011', 'Field', 2.5, 443.0, 157, '2 days', 5.72, 'Pm above situation she wear sort. How remain address see remember new.'),
('P1012', 'Experience', 0.27, 157.39, 29, '2 days', 10.24, 'Wife action north there practice. Line particular live.'),
('P1013', 'Goal', 1.77, 223.45, 60, '2 days', 0.82, 'Great exactly all. White pick believe send class physical.'),
('P1014', 'Shake', 4.48, 345.61, 189, '2 days', 14.78, 'This offer guess direction add. Result glass happen dinner movie no.'),
('P1015', 'Create', 3.72, 437.95, 139, '1 week', 15.29, 'Sure leave suffer system.'),
('P1016', 'Prevent', 3.26, 143.05, 116, '3-5 days', 8.3, 'Down thought bank side board. Fight similar western hope month.'),
('P1017', 'World', 0.36, 278.98, 8, '3-5 days', 13.31, 'Medical natural where game well find radio.'),
('P1018', 'Require', 2.29, 223.13, 119, '3-5 days', 17.22, 'Result personal fine suffer. Present need pattern break suggest. Officer letter speech.'),
('P1019', 'Data', 1.6, 167.57, 84, '1 week', 16.86, 'Maintain all her. Her environmental so can drop.'),
('P1020', 'Site', 1.36, 115.11, 75, '1 week', 11.28, 'Line really account. Science lot else.'),
('P1021', 'Consumer', 4.98, 288.44, 27, '2 days', 6.53, 'Provide serious occur former day course party. Race add special former three service.'),
('P1022', 'If', 3.59, 111.71, 153, '3-5 days', 3.19, 'Religious reveal another serious question. Network true would wait.'),
('P1023', 'His', 0.27, 141.91, 8, '3-5 days', 18.88, 'Crime join lead activity mission political sound. Must whatever example rate.'),
('P1024', 'Them', 2.2, 430.14, 13, '1 week', 5.34, 'Ready but best account growth third. Difference everybody culture space me yard join.'),
('P1025', 'Dream', 1.3, 89.1, 95, '2 days', 5.91, 'Resource hospital answer order such scene treat. Her significant side painting expect someone.'),
('P1026', 'Congress', 1.86, 440.27, 42, '3-5 days', 2.69, 'Almost think read network. First simply next his.'),
('P1027', 'Analysis', 0.87, 285.9, 131, '2 days', 4.28, 'Face order mind reach network. Dinner accept general.'),
('P1028', 'Popular', 3.06, 224.84, 2, '1 week', 8.2, 'Western sign surface big only. Attack including full our. Near front glass season.'),
('P1029', 'Able', 4.92, 263.77, 3, '3-5 days', 6.73, 'Character PM professional reach adult he product other. Power together song anything.'),
('P1030', 'Type', 4.69, 461.57, 70, '1 week', 9.71, 'Minute science plan experience wrong thousand charge force. Between better quickly what.'),
('P1031', 'Street', 0.39, 148.62, 75, '1 week', 13.71, 'Parent source pressure finish. Card appear impact lead. Election continue here building.'),
('P1032', 'Piece', 4.49, 488.08, 94, '1 week', 14.81, 'Worker ball heavy strong alone performance. Nature seven I key ability far.
System indeed common.'),
('P1033', 'Control', 3.2, 454.22, 91, '1 week', 19.89, 'Significant religious yet. Former want foot upon realize.'),
('P1034', 'Large', 1.61, 219.12, 195, '2 days', 10.25, 'Bar black rule mean factor act price long.'),
('P1035', 'On', 1.98, 431.57, 2, '3-5 days', 13.48, 'Light seven authority will how father. Hand hand itself.'),
('P1036', 'Allow', 1.94, 194.3, 109, '1 week', 19.72, 'Continue need business pretty TV player water. Surface instead model test commercial woman.'),
('P1037', 'Improve', 3.21, 158.87, 184, '3-5 days', 2.4, 'Decade you lot interest arrive conference election. Professional center central both trial.'),
('P1038', 'Know', 0.69, 275.68, 25, '3-5 days', 5.14, 'Only natural actually under. Condition wind artist turn drug trouble a.'),
('P1039', 'Worry', 4.9, 335.88, 102, '2 days', 19.21, 'Throw region control prevent. Large population often environmental could.'),
('P1040', 'Middle', 3.06, 397.41, 70, '2 days', 13.53, 'Kind standard agency choose food often see. Film knowledge mouth everyone professional thank.'),
('P1041', 'Indeed', 4.73, 297.82, 99, '2 days', 5.99, 'Attorney represent fish yourself. Many dream process consider me.'),
('P1042', 'Out', 1.42, 471.69, 31, '2 days', 11.96, 'More paper listen. Rich talk situation difficult reduce affect.'),
('P1043', 'Well', 2.78, 346.4, 1, '2 days', 16.63, 'Peace shoulder end future deep ahead result. Year whether actually capital writer smile them admit.'),
('P1044', 'Local', 4.7, 222.55, 37, '3-5 days', 0.86, 'Prove stage car above. Allow economic live.'),
('P1045', 'Hour', 3.02, 263.59, 178, '3-5 days', 1.2, 'Network young east. Up appear process.'),
('P1046', 'Discover', 0.58, 136.15, 186, '1 week', 15.76, 'Eight process let bag. Growth give read amount pay character. Color want follow natural.'),
('P1047', 'Writer', 2.44, 190.29, 12, '3-5 days', 9.0, 'Year partner order girl certainly. Hear either main win. Chance fear until nation.'),
('P1048', 'Effort', 1.51, 338.11, 9, '1 week', 7.35, 'Top hour drop end eight trial. Foot vote power community national.'),
('P1049', 'Feeling', 0.98, 210.76, 163, '3-5 days', 12.22, 'Outside get who particular government player. Trade understand everything edge share fish value.');

INSERT INTO RegularUsers (username) VALUES
('jerry25'),
('grantjames'),
('colemanbrittany'),
('ipatrick'),
('cookecolin'),
('bjohnson'),
('arobinson'),
('ccalhoun'),
('davenportjessica'),
('wallacejacob'),
('brianna36'),
('brittany79'),
('rangelamy'),
('dustinwilson'),
('robertsjulia'),
('clopez'),
('bsimmons'),
('colton14'),
('rojasstephanie'),
('hhawkins'),
('matthewpearson'),
('bauerchristopher'),
('deborahgalloway'),
('daniel34'),
('justin38'),
('bpage'),
('wbaker'),
('sbarnes'),
('fordthomas'),
('melissalester'),
('cnewton'),
('angelasmith'),
('caseykimberly'),
('staceyoneill'),
('mnelson'),
('david65'),
('mendozaannette'),
('linjade'),
('bensondavid'),
('tammysmith'),
('derek75'),
('jonathanmorris'),
('powersbryan'),
('chelsea28'),
('lucaschristine'),
('burnsjessica'),
('twilson'),
('snyderalexa'),
('claudia27'),
('vburns'),
('zcrawford'),
('travis30'),
('sheamonica'),
('xcrane'),
('leahandrade'),
('friedmancindy'),
('daniel74'),
('tjohnson'),
('vgreen'),
('christy48');

INSERT INTO ShopOwners (username) VALUES
('melissamitchell'),
('qrodriguez'),
('melindajackson'),
('melissacoffey'),
('justin45'),
('jessewood'),
('patrickharvey'),
('joseph57'),
('speterson'),
('hughesashley'),
('sphillips'),
('croberts'),
('roneill'),
('danielle74'),
('doris44'),
('leerobert'),
('mgriffin'),
('ogibbs'),
('staceymiller'),
('wsutton');

INSERT INTO Admins (username) VALUES
('richardsjanet'),
('moonlisa'),
('elizabethperry'),
('macdonaldallison'),
('eriley');

INSERT INTO Shops (id, shop_identifier, rating, sales_volume, owner_username) VALUES
(1, 'major-produce-get', 4.04, 259, 'melissamitchell'),
(2, 'line-strategy', 3.81, 739, 'qrodriguez'),
(3, 'ready-imagine', 2.54, 31, 'melindajackson'),
(4, 'hair-political', 3.93, 123, 'melissacoffey'),
(5, 'tonight-but', 1.43, 761, 'justin45'),
(6, 'north-energy-easy', 4.59, 970, 'jessewood'),
(7, 'station-break', 4.62, 915, 'patrickharvey'),
(8, 'network-word', 3.67, 36, 'joseph57'),
(9, 'but-early-property', 2.77, 475, 'speterson'),
(10, 'where-people-west', 1.75, 441, 'hughesashley'),
(11, 'often-lead-without', 2.41, 19, 'sphillips'),
(12, 'contain-manager', 2.61, 916, 'croberts'),
(13, 'friend-over-reflect', 4.37, 191, 'roneill'),
(14, 'present-bit-drop', 1.07, 857, 'danielle74'),
(15, 'simple-through-goal', 1.39, 144, 'doris44'),
(16, 'gas-forget-answer', 1.57, 828, 'leerobert'),
(17, 'cost-those-dream', 1.27, 596, 'mgriffin'),
(18, 'staff-piece-good', 4.27, 638, 'ogibbs'),
(19, 'fire-nation-appear', 3.17, 361, 'staceymiller'),
(20, 'mouth-kind-three', 1.04, 807, 'wsutton');

INSERT INTO Addresses (id, user_username, address_text, postal_code) VALUES
(1, 'wsutton', '407 Hanson Mill, Lake Matthewport, SC 73209', '64727'),
(2, 'melindajackson', '9360 Brown Drive, Jessicatown, RI 69743', '99586'),
(3, 'jerry25', '282 Lisa Spring, South Franciscohaven, AZ 64326', '33012'),
(4, 'teresa90', '70998 Frazier Run Apt. 779, East Cathytown, PW 10575', '05789'),
(5, 'daniel74', '9017 Vargas Oval Apt. 220, New Victoriaville, GU 72867', '22123'),
(6, 'ogibbs', '002 Veronica Parkway Suite 884, Port Tracy, NJ 25895', '88125'),
(7, 'matthewpearson', '945 Thompson Hollow Apt. 343, Donnaport, DC 17957', '60055'),
(8, 'deborahgalloway', '74898 Boyd Squares, Jacobhaven, ND 22949', '35499'),
(9, 'cnewton', '9132 Walter Harbors, West David, IA 26394', '43822'),
(10, 'ugonzalez', '9694 Mckinney Inlet, Emilyfurt, OR 80216', '65160'),
(11, 'deborahgalloway', '75468 Williams Ways Suite 389, East Heatherchester, MS 32318', '31678'),
(12, 'dustinwilson', '132 Walter Avenue, Victoriaville, ME 69570', '85188'),
(13, 'hughesashley', '41627 Miranda Ranch Apt. 081, Port Bradleyberg, IN 74668', '60163'),
(14, 'hhawkins', '211 Christine Haven Suite 429, Port Thomas, DE 90154', '48016'),
(15, 'ugonzalez', '83390 Haley Unions Apt. 086, Port Linda, MI 21521', '05206'),
(16, 'travis30', '1235 Sharon Lights Apt. 524, East Georgeville, OK 06070', '05363'),
(17, 'trocha', '4103 David Loaf, Rodriguezmouth, VA 25215', '51161'),
(18, 'colton14', '2818 Stephanie Haven, East Debra, VT 89702', '77315'),
(19, 'rojasstephanie', 'PSC 3914, Box 2197, APO AP 47597', '16330'),
(20, 'vburns', 'USNS Harris, FPO AP 60354', '20853'),
(21, 'grantjames', 'USNS Cameron, FPO AA 91005', '22727'),
(22, 'morrisonsara', '37614 Amy Trafficway Suite 191, Skinnerside, RI 73151', '77841'),
(23, 'sphillips', '5518 Conway Inlet Apt. 139, North Jacqueline, NH 10254', '09788'),
(24, 'moonlisa', '2577 Silva Drives, Mcguireland, CT 18200', '66575'),
(25, 'wsutton', '73692 Edward Trafficway Suite 444, North Carlosside, AL 55963', '80717'),
(26, 'mgriffin', '688 Albert Hollow Apt. 593, Mariastad, KS 36260', '73373'),
(27, 'ogibbs', '639 Love Courts Apt. 438, New Josephmouth, AS 05932', '09664'),
(28, 'patrickharvey', '850 Shannon Junctions, Theodoreland, AK 91588', '24783'),
(29, 'zcrawford', 'USS Cordova, FPO AA 59178', '27303'),
(30, 'zcrawford', '473 Perez Trail Suite 081, New Johnview, IA 07223', '63806'),
(31, 'wsutton', '0047 Golden Ville Apt. 733, Bradshawton, MH 96484', '58561'),
(32, 'bjohnson', '4967 Paul Camp, Codyfurt, SD 28412', '51227'),
(33, 'mgriffin', '41029 Collier Underpass Suite 948, Graymouth, AR 68603', '30194'),
(34, 'daniel74', '12039 Williams Island, North Marissaborough, MA 56149', '59639'),
(35, 'ugonzalez', '170 Catherine Underpass, East Troy, VA 68756', '33258'),
(36, 'travis30', '708 Cole Inlet, Port Meghanhaven, MA 74181', '31102'),
(37, 'vburns', '9449 Victoria Route, New Joan, ND 62645', '00719'),
(38, 'brianna36', '743 Benjamin Wells, East Christinaview, ID 60348', '46075'),
(39, 'chelsea28', '025 Kylie Estates, East Karen, CA 16245', '33707'),
(40, 'doris44', '40541 Graham Manor Apt. 355, West Brent, MS 10724', '81993'),
(41, 'daniel34', '53699 Powers Viaduct, New Leah, WA 42538', '59173'),
(42, 'xcrane', '645 Kyle Route, South Kristenburgh, IN 95656', '83227'),
(43, 'grantjames', '6804 Todd Streets Apt. 346, East Michael, PW 58546', '74228'),
(44, 'caseykimberly', '1034 Tyler Centers, East Ian, AL 16858', '93492'),
(45, 'chelsea28', '537 Tony Centers, Lindaton, DE 22571', '12893'),
(46, 'doris44', '5730 Gomez Squares, Tammymouth, TX 91497', '46510'),
(47, 'eriley', '954 Erika Points Apt. 705, Kaitlynfurt, ID 84059', '05532'),
(48, 'justin38', '370 Phillip Falls Suite 433, Richardtown, CO 28394', '16835'),
(49, 'claudia27', '3235 Ann Gateway, North Shannon, SD 69668', '99668'),
(50, 'sheamonica', '4680 Jonathan Drives Apt. 863, South Anthonyfurt, NM 75064', '67341'),
(51, 'wbaker', '146 Kurt Crest Suite 334, New Amandaborough, WY 94760', '74999'),
(52, 'twilson', '4164 Lauren Lights Suite 224, South Johnnyhaven, UT 41091', '93762'),
(53, 'christy48', '39873 Sanchez Ford Suite 345, Johnbury, LA 30039', '60462'),
(54, 'mnelson', '0647 Richardson Manor, West Hannahbury, FM 66996', '28106'),
(55, 'leerobert', '288 Jimenez Plain Apt. 631, Johnsonburgh, WA 61809', '81068'),
(56, 'cnewton', '41600 Salazar Courts, Mistyborough, VI 25101', '20296'),
(57, 'melissamorris', '99807 Morgan Avenue, Smithville, PW 21523', '41361'),
(58, 'deborahgalloway', '672 Chavez Plain Suite 662, Castroburgh, PR 23048', '41553'),
(59, 'leahandrade', '7525 Gonzalez Cliffs Suite 484, West Samantha, RI 86097', '70161'),
(60, 'matthewpearson', '66610 James Freeway Apt. 878, Allenland, ME 83526', '44839'),
(61, 'erika75', '4622 Shane Cliff, Daletown, UT 16242', '73657'),
(62, 'staceymiller', '705 Dennis Knoll Apt. 668, Lake Kyle, NM 27895', '82153'),
(63, 'ariaskrystal', '4007 Carrie Trace, West Karina, MH 96254', '50331'),
(64, 'snyderalexa', '91284 Stephanie Squares, New Rachelshire, OH 66452', '25518'),
(65, 'deborahgalloway', '3962 Luis Meadow, Lake Annaland, MD 15152', '35946'),
(66, 'teresa90', 'PSC 7840, Box 6623, APO AP 20528', '40287'),
(67, 'mnelson', '340 Moore Drives, Julianville, AZ 20418', '10702'),
(68, 'joseph57', '68453 David Springs, Cervantesstad, VA 31115', '44814'),
(69, 'ariaskrystal', '405 Dean Keys Apt. 055, East Troyfurt, ND 82761', '91451'),
(70, 'hhawkins', '2617 Kevin Turnpike Suite 473, Roseside, AS 30090', '21140'),
(71, 'staceyoneill', '2328 Martinez Junction, Townsendville, SC 43161', '27529'),
(72, 'patrickharvey', '8093 Murray Spring, Kathrynshire, GA 36264', '63163'),
(73, 'daniel74', '082 Lauren Stream, Benjaminland, MH 52581', '44089'),
(74, 'davenportjessica', 'PSC 8973, Box 0405, APO AE 43798', '06402'),
(75, 'colton14', '612 Natalie Spur Apt. 791, South Sharimouth, PR 69709', '45026'),
(76, 'leerobert', '6208 Hughes Green Suite 165, Dayfort, DE 14951', '45739'),
(77, 'colemanbrittany', '923 Yang Fork Apt. 558, South Stephen, CA 28440', '75112'),
(78, 'melissacoffey', '7573 Brewer Neck, West Paul, WA 16922', '87073'),
(79, 'sheamonica', '3582 Ronald Fords Suite 369, Mistymouth, FM 71637', '75967'),
(80, 'trocha', '27452 Evans Plains Apt. 032, North Garytown, MH 29644', '48551'),
(81, 'dustinwilson', '000 Corey Squares Suite 498, Williamsmouth, MS 03851', '81196'),
(82, 'dustinwilson', '97268 Watson Court, Port Marc, WA 97823', '92088'),
(83, 'clopez', '23359 Reynolds Brooks Suite 100, Welchchester, UT 32583', '58784'),
(84, 'doris44', '62737 Christina Extensions Suite 209, Ellenview, HI 69012', '64704'),
(85, 'teresa90', '452 Sarah Walk Apt. 721, Sheliaport, AS 44359', '26874'),
(86, 'jonathanmorris', '659 Dylan Junction Apt. 565, West Patrickmouth, OR 64003', '01259'),
(87, 'melindajackson', '9832 Diaz Prairie, North Reginald, SD 45798', '50700'),
(88, 'twilson', '5780 Bryce Expressway Apt. 227, Kristentown, PA 59721', '37622'),
(89, 'ugonzalez', '38568 Joseph Plain, North Bryan, LA 42962', '69203'),
(90, 'danielle74', '60449 Robinson Pass Suite 925, Port Mary, AR 37222', '29570'),
(91, 'ugonzalez', '585 Vincent Crossroad, Stokesfurt, KY 08098', '51134'),
(92, 'bsimmons', '971 Khan Ford Apt. 163, Warrenberg, UT 27559', '16561'),
(93, 'rojasstephanie', '91345 Horton Loaf Suite 882, Port Nicoletown, WV 62306', '50047'),
(94, 'ccalhoun', '392 Lori Manors, Lake Javier, GU 45566', '85977'),
(95, 'daniel74', '3467 Robinson Divide Suite 495, Tylerstad, NE 16310', '69914'),
(96, 'hughesashley', 'PSC 6506, Box 2695, APO AA 06282', '12781'),
(97, 'erika75', '889 Fox Lodge, Moniquebury, WA 58885', '63439'),
(98, 'bsimmons', '49091 Katherine Cliffs, Campbelltown, RI 84107', '54082'),
(99, 'david65', '274 Blake Meadows, Elizabethberg, PA 35082', '04091'),
(100, 'staceymiller', '94615 Matthew Mountain, South Jodiland, PA 73708', '58968'),
(101, 'bsimmons', '9640 Benjamin Locks, East Stephanietown, MD 83328', '72757'),
(102, 'ggutierrez', '5378 Kenneth Rest Apt. 271, Fergusonville, GU 66173', '86348'),
(103, 'william68', '33745 David Field, Lake Manuel, TN 42096', '81281'),
(104, 'brittany79', '9542 Dixon Court, Atkinsview, AS 90379', '43121'),
(105, 'rangelamy', '6245 Timothy Divide, Ashleyville, AS 17712', '44368'),
(106, 'patrickharvey', '0023 Wallace Locks Suite 602, South Ryan, VT 13110', '01870'),
(107, 'jonathanmorris', '2593 Peter Stravenue Apt. 763, Jeffersonton, KS 84114', '38743'),
(108, 'mnelson', '6988 Nelson Point, Port Kaylamouth, AL 57058', '15102'),
(109, 'cookecolin', '5444 Mary Mission, New Brianview, PA 63803', '22316'),
(110, 'sbarnes', '95853 Gill Mission Apt. 802, Port Margaretberg, MP 00936', '74504'),
(111, 'wsutton', '854 Simpson Crest, Rodrigueztown, MA 55165', '72000'),
(112, 'croberts', '7110 Robinson Neck Apt. 334, Rasmussenborough, MN 79858', '69976'),
(113, 'matthewpearson', '7834 Adams Course, Muellerstad, IA 50210', '19361'),
(114, 'ariaskrystal', '55290 Linda Fields Suite 927, New Jeanshire, OK 49542', '98294'),
(115, 'rojasstephanie', '9116 Davidson Creek Suite 104, South Daniel, DE 56509', '99042'),
(116, 'melissalester', '8266 Arthur Knoll, Codyport, IN 76952', '07110'),
(117, 'hhawkins', '69931 Williams Streets, South Edwin, PR 73381', '93839'),
(118, 'laura25', '616 Willie Isle, Smithstad, AL 25259', '03007'),
(119, 'erika75', '05258 Hoffman Mountain, New Travis, AS 05440', '80945'),
(120, 'brianna36', 'USCGC Estrada, FPO AP 39691', '57319');

INSERT INTO Messages (id, sender_username, receiver_username, message_text, sent_at) VALUES
(1, 'melissalester', 'dustinwilson', 'Clearly single suffer accept court too. Sing mind keep majority detail wrong tough entire.
Series woman car manage. Land dream full record property control. Often food option.', '2025-04-02 20:19:21.005035'),
(2, 'macdonaldallison', 'croberts', 'Certainly arrive second hundred night character. Traditional think hit position amount gun husband. Commercial only spring trade else heavy.', '2025-04-13 09:58:27.086213'),
(3, 'xcrane', 'snyderalexa', 'When true leader expert seat. Son approach leave military might half each. Draw leg test party report.
Hundred news sort most. Plan have artist mother. Piece vote up begin interest.', '2025-04-22 13:42:40.115503'),
(4, 'jerry25', 'justin38', 'Or address keep. Wrong nor occur positive top security painting.
Different decision ready social check.', '2025-01-14 11:07:27.183017'),
(5, 'william68', 'leahandrade', 'Everyone world alone perform study public. Lead unit speech energy similar property. And serious fire.', '2025-01-23 19:47:02.953608'),
(6, 'fordthomas', 'tjohnson', 'Soldier administration conference toward will contain seven. At number position face without director surface. Bill up magazine professional ground.
Happy quickly media. Feel daughter through.', '2025-04-10 11:45:41.810391'),
(7, 'grantjames', 'speterson', 'Grow near choose yet region student generation. Worry catch light data focus. Share role director.', '2025-01-28 20:31:19.712696'),
(8, 'brittany79', 'lucaschristine', 'Question physical they crime white back. Parent what process. Item case move benefit.
Degree daughter fall give reach. Mind product later born role.', '2025-02-27 17:03:49.153075'),
(9, 'dustinwilson', 'wallacejacob', 'Do anything lay box action. Range low bank test order two produce car.', '2025-03-22 07:16:33.345439'),
(10, 'snyderalexa', 'bpage', 'Return stay key here such.
Skin draw argue deal challenge member. Former shake us director father since return.
Kind structure sometimes draw. Policy memory where admit produce.', '2025-04-29 08:37:29.211691'),
(11, 'trocha', 'staceymiller', 'Deal that Democrat behind red. Recently go soon.
Ready threat should dream. Fear water during thus.
Phone where according against suddenly. Film white language degree ok.', '2025-03-27 14:55:39.291067'),
(12, 'claudia27', 'leahandrade', 'Himself represent news. Black wall national about price matter. Without wide bar save store.', '2025-04-20 22:20:34.920900'),
(13, 'wbaker', 'mnelson', 'Manager dog likely computer. Listen public simply policy hour. Camera financial manage tax.', '2025-03-18 02:15:17.054137'),
(14, 'melissamitchell', 'linjade', 'Civil ten soon real yet environmental. Require development down effect conference free other. Society wind plan your.', '2025-01-05 01:24:38.616776'),
(15, 'patrickharvey', 'angelasmith', 'Middle so challenge term too. Weight chair future partner entire reality end.
Short central issue which major talk activity. Include save but best toward require.', '2025-04-29 11:56:30.359809'),
(16, 'joseph57', 'william68', 'Store detail author dinner. Page sense example late admit recent those memory. Sister study measure positive purpose three too.
Employee item toward without radio idea. Challenge mind alone rock law.', '2025-03-06 10:36:16.041563'),
(17, 'joseph57', 'matthewpearson', 'Well available these bit. Loss about both its.
Tell dark society adult after indicate. Site movement notice ten Congress professor responsibility. Carry provide shoulder never.', '2025-01-28 21:59:03.051349'),
(18, 'john73', 'jonathanmorris', 'Account card to poor person behind medical let. Necessary magazine here usually. She instead note sport live. Child I rise sure staff.', '2025-02-12 21:19:08.782536'),
(19, 'jessewood', 'colemanbrittany', 'Because bar expert parent act focus. End red them realize size owner who. Adult form nature lay case.
Discuss begin myself act well pick. Keep town every. Minute however none end foreign test.', '2025-03-29 19:45:37.730280'),
(20, 'egraham', 'sheamonica', 'Now somebody own her discover interview speak. Physical traditional race offer six. Right wrong behind main include some.', '2025-03-01 05:34:31.142371'),
(21, 'caseykimberly', 'cnewton', 'Friend focus interview direction husband. Hope once even star fight all stand. Group discussion prove cause recent effect of.', '2025-02-01 02:47:18.095729'),
(22, 'john73', 'staceymiller', 'Evidence sign guy example share day discussion. Fund none bed specific. Involve who collection east require lot. Own large although reason thank network social.', '2025-03-06 06:58:07.796244'),
(23, 'doris44', 'bjohnson', 'Image act doctor officer difference program. Do wall build finally issue third.
Significant usually board environmental. Activity positive specific such.', '2025-03-03 16:35:08.784823'),
(24, 'sheamonica', 'roneill', 'Baby system argue that project. Blue response act.
Successful board unit minute campaign begin southern. Himself long great inside.
Never risk how sea part. Reason anyone drive enjoy for.', '2025-03-10 12:32:41.328175'),
(25, 'vgreen', 'snyderalexa', 'Expect each key yard clearly. Strong until executive prove cut treat artist audience. Different agreement candidate green moment fast Mrs.', '2025-03-22 13:00:00.542457'),
(26, 'elizabethperry', 'sphillips', 'Say marriage may look notice. Very discover media bring.
Play model small person card despite. Whether experience job performance shake hospital. Small save far be rate.', '2025-01-25 05:11:36.826896'),
(27, 'eriley', 'jerry25', 'Hour one general arrive behavior. President health as box large small rise season. National modern child reason field.', '2025-02-09 08:00:28.226800'),
(28, 'patrickharvey', 'trocha', 'Alone police couple catch rock measure. Peace bank cold sell friend something.
Long personal expert anyone. Find under region still cultural form show. Against even situation human church public law.', '2025-02-07 20:02:46.587921'),
(29, 'justin38', 'daniel34', 'Shake imagine against place smile public news. While carry hand worry glass. Ago your establish include keep sign actually.', '2025-03-29 21:19:51.571687'),
(30, 'snyderalexa', 'ugonzalez', 'Board grow again throw.
If tree meet ago long. Particularly everyone mission well meeting always capital. Prevent ready center be poor value class authority.', '2025-03-02 00:47:12.314160'),
(31, 'croberts', 'snyderalexa', 'Watch beautiful art large sometimes. Organization turn sing stage ago. Sound need as behavior.', '2025-03-04 16:57:19.868142'),
(32, 'melissalester', 'bauerchristopher', 'Century away personal phone goal move tonight. Live firm people born opportunity I.
Account glass agent report leg idea.
Agree at head any common. Prevent field important.', '2025-04-29 03:40:33.555495'),
(33, 'zcrawford', 'sheamonica', 'They great know involve but authority specific. Wall own degree today final once. Budget where yourself continue I model arrive sense.', '2025-01-24 14:42:26.855390'),
(34, 'wsutton', 'bensondavid', 'Until stand trade matter perhaps position. Water clear against space my sort hot.', '2025-02-26 18:26:00.933905'),
(35, 'rangelamy', 'hughesashley', 'Resource window score whether rise late interest. End Mr right job better bring. Player garden medical home explain whether use.', '2025-01-24 04:47:03.458246'),
(36, 'trocha', 'grantjames', 'Discuss enjoy model red billion. Local market message.
Rise finally compare style including easy door. Movement bag power win born arm.', '2025-03-26 18:37:04.027679'),
(37, 'grantjames', 'christy48', 'Senior hit how manage which stuff few perform. Family according commercial tonight.
Even blue administration teach management.', '2025-03-02 16:43:11.248022'),
(38, 'ipatrick', 'staceymiller', 'Yet everything particularly night. Truth do outside girl night summer.
Yes bar avoid. Research cold between home develop down.
Also them leg majority. Agreement matter catch help style tonight.', '2025-02-17 21:02:10.898492'),
(39, 'robertsjulia', 'travis30', 'Sister interview spring us war no true ahead. Care difficult month movie plant kitchen just.
This his reveal choose. Type onto whose candidate forward thank someone. On candidate professor rule.', '2025-01-19 17:27:13.378814'),
(40, 'joseph57', 'melissamitchell', 'Skill personal quickly enough.
Red push month create pull point computer. Entire administration animal employee some speech really.', '2025-04-10 21:13:57.388453'),
(41, 'linjade', 'hhawkins', 'Style report college back outside. Sport out manager role.
Treat group spring exactly. Office despite sure enter. Usually always talk we face talk.', '2025-02-27 21:03:22.384574'),
(42, 'laura25', 'david65', 'Do along evidence government down would together. Officer green often data film point. Apply share individual go.', '2025-01-13 12:24:35.861068'),
(43, 'justin38', 'ogibbs', 'Economy case notice line bag. Attack prepare member fall none.
Visit such weight growth sport down. Raise expert move. Budget thank special quality direction perhaps paper.', '2025-02-01 14:26:00.583206'),
(44, 'melissacoffey', 'ccalhoun', 'Animal beautiful wonder measure already heavy prevent. Partner together set data compare four. Benefit remember site guy item approach.
Dog create deal.', '2025-04-12 03:56:04.641845'),
(45, 'fordthomas', 'wbaker', 'Consider hair inside record offer government.
Instead create this senior parent.', '2025-04-17 11:56:14.369342'),
(46, 'melissamitchell', 'bauerchristopher', 'Would happen own none remember middle. Nearly though world participant. Month toward every far huge dream across avoid.', '2025-01-18 05:09:09.842578'),
(47, 'croberts', 'melindajackson', 'Check data government recognize he. Hear less stage Mr build development market. Toward often indeed yet.', '2025-02-16 00:04:15.056887'),
(48, 'cnewton', 'burnsjessica', 'Career language history size anything total. Wear end painting perform agent.
Win national pattern miss shoulder road strong she. Through long term security.', '2025-04-20 07:41:50.219442'),
(49, 'tlong', 'justin38', 'Commercial product help across. Likely lot nice against agent police.
Clearly morning make. End whatever section question. Place least significant should.', '2025-02-19 12:33:03.073912'),
(50, 'friedmancindy', 'ariaskrystal', 'Free look dream perform turn middle. One wall open part budget. Serve seek ever rich not thing.
Understand evening open yourself. Want seem participant mouth story.', '2025-03-28 23:53:49.459873'),
(51, 'justin38', 'david65', 'Sister everyone establish suggest must approach. Story but today ever. Hear rock fill only actually pull into.
Seem policy increase. Than decide pattern game event light.', '2025-04-29 13:38:50.461676'),
(52, 'trocha', 'wallacejacob', 'Interesting manager strong what agree property.
Remain board service structure face first contain. Close help turn than when the street. Trouble candidate different try understand including.', '2025-01-24 06:28:37.658130'),
(53, 'vgreen', 'burnsjessica', 'Friend option while community thank lose light. Hot why early audience watch when bed world. Contain against executive dog the figure.
Until enter position else hear amount. Into scene with matter.', '2025-04-09 08:29:42.957769'),
(54, 'sbarnes', 'elizabethperry', 'According hour spring small within child when hotel. Feel what view industry yard move.
New value happen idea allow alone. Yourself responsibility great reveal similar worry.', '2025-02-09 09:44:42.161500'),
(55, 'eriley', 'rojasstephanie', 'Worker science carry wear five. Food morning per building. Concern account summer understand participant suddenly employee.
Fund behavior as without man change.', '2025-04-20 05:57:27.215229'),
(56, 'sbarnes', 'leerobert', 'Again might bit dinner. Training computer yes response.
Forward know loss probably. Past whatever worry get miss character light where.', '2025-01-05 15:31:41.657523'),
(57, 'mendozaannette', 'caseykimberly', 'Identify myself read skin discover attention. Describe political research argue check along.
Air step clearly order. Mind voice pass baby bag one return. Accept avoid however black with whom.', '2025-02-26 21:47:34.959254'),
(58, 'staceymiller', 'tammysmith', 'Animal teach out from fund let party evidence. Clear station professional six pick ahead.', '2025-01-02 08:35:23.009927'),
(59, 'sphillips', 'angelasmith', 'Offer young soon live opportunity recent free. On many increase test. Performance letter plant but.
West college western yourself rather challenge. Again quality resource most prepare.', '2025-03-10 12:27:27.242917'),
(60, 'laura25', 'wsutton', 'Kind must memory. Matter character score hospital article candidate one imagine. Hotel test to read party leader.', '2025-01-23 06:51:33.636735'),
(61, 'bsimmons', 'cnewton', 'Democratic brother least education arm whatever manager. Hit training trial social.
Bring sometimes there color capital or maybe. Available statement PM. Bit season pretty center federal.', '2025-04-27 02:55:47.586795'),
(62, 'leahandrade', 'william68', 'Need turn mission once animal. Mean forward ever our figure fund name television.
Adult later attention political. Age him tend describe.', '2025-04-24 07:33:52.499348'),
(63, 'danielle74', 'jerry25', 'I avoid natural fire summer. Huge plan table Republican view focus business.
Always describe smile remember group manage gun. Chair American interesting education letter peace.', '2025-03-28 10:13:53.031026'),
(64, 'vburns', 'deborahgalloway', 'Indeed politics near themselves task second. Stuff heavy community ten into speak degree poor.
Strategy evidence fear red.', '2025-02-06 16:40:34.295397'),
(65, 'patrickharvey', 'melissamorris', 'Indicate space whole business provide chance local toward. Age focus everything future trip crime rich medical.', '2025-02-13 01:44:17.901525'),
(66, 'melissamorris', 'xcrane', 'Travel total guy western structure avoid. Image wonder resource move. Garden say more detail city general scene.', '2025-04-19 18:02:56.095132'),
(67, 'cnewton', 'xcrane', 'Unit image at someone buy. Brother let center message simply.
First where participant. Rise fill imagine body writer book. Boy bill service pay.
Stand will thing. Food build president sing note them.', '2025-03-30 03:04:48.490379'),
(68, 'rojasstephanie', 'egraham', 'Together positive involve still industry since. State military night without dark. Available seat drive.', '2025-03-20 14:29:47.183843'),
(69, 'hhawkins', 'christy48', 'Perhaps sometimes and however word. Eye different fight contain sing voice culture.
Range seem above pull. You speech stuff. Hit fast leader indicate ball despite.', '2025-04-02 06:58:43.446109'),
(70, 'sheamonica', 'tjohnson', 'Drop quality speech. It front shake room sit.
Because above growth. Standard machine serve lay new everyone.', '2025-04-14 23:13:37.833099'),
(71, 'laura25', 'derek75', 'Much late find born stay newspaper. Per method senior fine we. Personal involve radio policy evidence family.', '2025-01-02 02:22:53.345964'),
(72, 'bensondavid', 'angelasmith', 'Turn page down she natural evening popular. Color later either camera think.', '2025-04-09 04:01:55.498418'),
(73, 'leahandrade', 'croberts', 'Commercial hour rate reflect home common worker. Key staff our positive personal beyond whole. Ok to region forget by decision seek.', '2025-02-27 17:20:35.276363'),
(74, 'vburns', 'twilson', 'Example sometimes by front employee unit author save.
Help strategy out cause argue. Dream level research. Season fill within probably purpose stop.', '2025-01-28 08:30:13.649139'),
(75, 'xcrane', 'ogibbs', 'Bad security tend week. Poor again despite PM single might material.
Knowledge enjoy free air cover military. Turn standard network within.', '2025-01-14 18:15:57.355877'),
(76, 'cookecolin', 'twilson', 'Must service see thing buy. Animal hospital trade population business specific third. Economic sound organization perform apply prevent happy management.', '2025-01-02 12:09:15.375488'),
(77, 'ipatrick', 'bjohnson', 'Report your chance else. Store bring right spring group mission over. Among officer together foreign.', '2025-04-19 07:51:24.770421'),
(78, 'derek75', 'zcrawford', 'Mention ready throughout middle politics investment suddenly. Economy person do daughter part painting choose. Hour bar peace smile.', '2025-01-22 06:11:07.704572'),
(79, 'brianna36', 'joseph57', 'Board set toward national money claim wind. Simple so when family energy interest. Wonder suddenly shake scientist common number sea.', '2025-04-28 09:55:23.566720'),
(80, 'melissamorris', 'staceyoneill', 'Budget good think season could happy including law.
Yard green glass despite. Bill land much might. Into put no anyone check. According glass offer tend trial at.', '2025-02-11 16:22:15.766828'),
(81, 'hhawkins', 'jonathanmorris', 'Deal decade still might think control you project. Stand officer social wide. Herself together house between campaign analysis room.', '2025-03-15 18:13:24.365444'),
(82, 'bauerchristopher', 'erika75', 'Water building maintain.
Answer Democrat day majority establish. Trouble owner for allow growth.
Senior family the. Stock daughter behavior space mind cover value safe.', '2025-02-06 13:02:58.304086'),
(83, 'vburns', 'mendozaannette', 'Yourself onto sit spring trouble operation. Across section choice fight enter.
Raise cold give bag. Store success tell risk. Still any meeting book bag ball.', '2025-04-30 11:34:17.251573'),
(84, 'melissacoffey', 'wallacejacob', 'Week how history. Down young better mind throw development more.', '2025-04-21 15:45:54.291902'),
(85, 'melissalester', 'brianna36', 'Hard knowledge into buy Republican note eye. Stand remember perform ground herself guess seat.
Major speak factor fall thousand. Avoid where keep process. Rise develop difficult save.', '2025-01-23 22:04:05.344552'),
(86, 'wbaker', 'sbarnes', 'They which court do buy view. Course business buy seek especially first.', '2025-01-14 20:58:49.699770'),
(87, 'colton14', 'morrisonsara', 'While court candidate name girl join better. Next even their identify would.
Month year boy. Likely environmental score Democrat class. How successful several crime month.', '2025-01-03 14:28:04.982861'),
(88, 'teresa90', 'melissalester', 'Employee rule more general carry it debate. Wide debate standard responsibility source behavior price.', '2025-04-11 23:39:19.941557'),
(89, 'vburns', 'tlong', 'Lose particular true job between. Medical live official rate suddenly charge month sometimes. Before good do together.', '2025-03-14 12:34:14.597043'),
(90, 'roneill', 'sbarnes', 'Affect discuss life opportunity feeling. Long environmental attention condition until increase technology. Soon cause growth story piece rich church.', '2025-02-21 20:09:01.245732'),
(91, 'cookecolin', 'william68', 'Wide face year help major. Purpose find investment move.', '2025-03-09 17:10:15.735922'),
(92, 'salazargregory', 'melissamitchell', 'Market something sit peace moment. Miss forward to how pull other. Structure spring treatment positive development.', '2025-02-20 04:47:25.696661'),
(93, 'tlong', 'vgreen', 'In north onto surface approach cover. Hear in certainly.
Plan prove message. Contain next lot know possible up.
Sister present administration also ground. Reality Mr free community same both.', '2025-04-26 13:59:28.288805'),
(94, 'robertsjulia', 'wsutton', 'Really place paper improve most case item. Decade painting forward vote.
Executive fly term would some act happen.', '2025-01-23 23:17:04.476417'),
(95, 'hhawkins', 'qrodriguez', 'Act reveal right. Meeting put believe middle ball win. Involve decide receive Mrs economy later.
Hair debate huge story me. Power she chance represent heart mouth beat. Break top what.', '2025-04-20 16:13:32.171240'),
(96, 'brianna36', 'mgriffin', 'Answer discuss sea at fish score nearly. Public benefit group anyone bit his offer reduce.', '2025-04-22 11:58:11.068073'),
(97, 'justin38', 'burnsjessica', 'None wrong protect operation show already something quite.
Often now cost floor agreement. Bit continue product ability. Box tell middle stuff.', '2025-02-20 12:13:36.735684'),
(98, 'melissalester', 'bpage', 'Nice will any its set heart.
Beautiful doctor occur home today. Area age election staff everything.', '2025-02-25 16:09:33.540355'),
(99, 'wbaker', 'elizabethperry', 'Hair them believe brother raise bar tough offer. Billion great white water about admit.
That none house fish throw clearly. Edge majority indicate personal. Already yeah could official short.', '2025-04-06 00:07:24.846025'),
(100, 'fordthomas', 'powersbryan', 'Success strong page fire. Within offer these industry our decade see.', '2025-04-17 09:12:39.692862'),
(101, 'doris44', 'bensondavid', 'Crime two defense mouth ready. Community window positive. Until able actually network industry military bed space.', '2025-01-06 22:48:23.834268'),
(102, 'bensondavid', 'moonlisa', 'Suddenly down where sometimes friend get. Scientist forget analysis none order early.', '2025-04-24 13:49:40.445427'),
(103, 'staceyoneill', 'leahandrade', 'Moment service memory term fine free send.
Same program truth vote. Nor expert ball agree wish article.
Hit they life vote whole brother laugh child. Minute program price north new.', '2025-01-23 22:39:04.684082'),
(104, 'melissalester', 'bensondavid', 'Tax beyond commercial analysis word. First trip behavior point. Eight stuff experience above author.', '2025-02-22 10:56:31.837150'),
(105, 'wallacejacob', 'ccalhoun', 'Indicate beyond knowledge professional than social. Effect we yet fall they join.
Up affect rest factor. Century record wait activity both make.', '2025-03-25 18:56:57.480864'),
(106, 'david65', 'ccalhoun', 'Serious Democrat and although. Whom environment and fear radio soldier able. Know commercial yourself store north difficult.
Official hotel nothing offer once new lay. Music who game fall.', '2025-04-20 01:05:19.536738'),
(107, 'leerobert', 'rangelamy', 'Data contain hair.
Pressure design debate season. Many mother may pass deep thank. Later office include see individual game face.', '2025-01-24 03:39:54.570510'),
(108, 'ugonzalez', 'christy48', 'Relationship do pull may. Mrs only buy majority onto yard top. Age poor become still.', '2025-02-07 18:33:37.195960'),
(109, 'brianna36', 'friedmancindy', 'As look probably do ask anything shake. Pull easy although street. Within tree professional institution have.', '2025-03-02 21:56:50.794527'),
(110, 'wsutton', 'bsimmons', 'Interest late kitchen statement sea radio represent.
Heart system build sort resource including. Score church view common bad. Worker would garden place ever.', '2025-01-16 20:28:08.246491'),
(111, 'sphillips', 'ggutierrez', 'Include many court rate enjoy region section foreign. Somebody scientist five bar officer hear soldier. Seek by argue seat course wait president PM.', '2025-01-15 18:15:16.521621'),
(112, 'staceymiller', 'wsutton', 'Bit change movie myself out financial. Soon young impact listen call. Whole TV able political understand in.
High doctor star pressure. Hospital serious break call subject.', '2025-01-31 17:30:19.012412'),
(113, 'bensondavid', 'derek75', 'Choice very above land. Budget event difficult under radio.
Whether phone agree law wide police involve radio. Really appear change PM. Next hand explain process.', '2025-03-15 22:38:38.998088'),
(114, 'william68', 'joseph57', 'Federal lay order type suggest. Approach property good give.
Could agree compare identify. During itself be pull create herself tell. Describe raise I.', '2025-04-23 05:22:20.295073'),
(115, 'twilson', 'trocha', 'Moment eye there before spring drug something degree. Two quality fill condition behavior air.', '2025-03-22 03:46:11.269588'),
(116, 'powersbryan', 'sbarnes', 'Care assume beat sport line or detail sister.
Too that nature whether walk big down. Strategy ground degree best risk within. Cup rock garden family show according involve.', '2025-03-21 10:02:25.674346'),
(117, 'brittany79', 'brianna36', 'Road possible theory wish. Interesting know street technology human continue.
Difference if ability image play back. Network lot newspaper hair well kitchen.', '2025-04-08 00:45:03.108098'),
(118, 'speterson', 'jerry25', 'Three mission myself such school. Hand three piece form wait.
Cut happy party relate fire. Look have reality. Chair something often agreement.', '2025-02-16 09:31:03.831900'),
(119, 'caseykimberly', 'justin38', 'Successful involve big until. Everybody type worry majority may. Learn animal many fly within yourself. Above just force approach trouble.', '2025-01-02 04:10:25.833931'),
(120, 'doris44', 'sheamonica', 'Evening pressure mouth war seat including back role.
Fund need girl accept second out still. All indeed cup raise free side.', '2025-02-12 23:07:59.670945'),
(121, 'justin45', 'teresa90', 'Police dog boy kitchen. Can serious time. Statement peace social think later.
Rock majority doctor their four. Size politics sport attack hope center teacher. Message whom where share.', '2025-02-13 13:41:45.161393'),
(122, 'ccalhoun', 'moonlisa', 'Worry against perform store story music recently. Crime already analysis draw list join and. Politics race modern people half.
Kid simply military prevent theory feel after.', '2025-01-14 01:21:45.155925'),
(123, 'sheamonica', 'brianna36', 'Piece beyond style discussion.
Allow analysis in feeling small performance. Home central week blood former. Out true million hear Mrs wrong.', '2025-04-04 09:47:18.408580'),
(124, 'croberts', 'morrisonsara', 'Far million discover mother.
Sense performance image address table million military. Rich physical major education weight suddenly understand.', '2025-01-31 15:50:04.853019'),
(125, 'john73', 'teresa90', 'Deal light court in. Forget test appear pay beautiful.
Population while scientist line appear tell newspaper firm. Care contain management.', '2025-03-14 00:03:49.695183'),
(126, 'dustinwilson', 'croberts', 'Service director certain officer keep when. Compare fish half PM.
Light one matter view. You production star. Ask learn strong.
Lot step international right. Issue anyone without chair arm thing.', '2025-04-07 09:02:16.667912'),
(127, 'angelasmith', 'burnsjessica', 'Seven ten event film small wish thousand. Culture pattern ten not. Fast top water force garden prepare.', '2025-01-14 22:42:50.286880'),
(128, 'chelsea28', 'melissamorris', 'Support tonight actually these little similar. Voice cause three. Road set food three push church try.', '2025-04-11 02:55:42.317682'),
(129, 'elizabethperry', 'egraham', 'Tell Democrat garden provide develop difficult campaign.
Matter especially involve protect.
Sure billion rest color language great democratic.', '2025-01-05 01:06:04.930265'),
(130, 'ggutierrez', 'grantjames', 'Other evening discussion everything fall. Surface mouth figure main real work prepare after.
Worry individual kid finally challenge. Final sign really cause. Station leader include stock.', '2025-01-24 16:05:14.535608'),
(131, 'davenportjessica', 'bauerchristopher', 'Far community upon reason child short office late. Off fine perhaps serve personal face investment.
Brother team reason public. That home enjoy be.', '2025-01-22 13:14:17.364253'),
(132, 'chelsea28', 'egraham', 'Side significant place sell team already. Officer radio medical want station.
Word us something entire. Role cup language never. Method laugh relationship bad fact task none.', '2025-01-22 02:55:25.585350'),
(133, 'melissalester', 'fordthomas', 'Radio over so into lay. Third join cause on knowledge. Word rise lot change herself move.', '2025-03-18 01:46:39.527765'),
(134, 'fordthomas', 'danielle74', 'Late technology sure wait current magazine. Difference sister be store in music. Positive what this since.
Mrs paper man soon this development.', '2025-02-07 08:10:13.140001'),
(135, 'bjohnson', 'wallacejacob', 'Whatever north network even expert yard specific. Hot key build their decade product. Stage another floor seek far.
Benefit now speech none expert interesting. Cost town way tax he.', '2025-02-19 17:57:55.252566'),
(136, 'bpage', 'angelasmith', 'Seven order money cause. Seem go way friend how. Though argue experience product north exist charge black. Strategy form first mean per party.', '2025-01-02 20:31:08.807787'),
(137, 'friedmancindy', 'wsutton', 'Brother health light author herself themselves between build. Parent agree do but sort recent top evidence. Choice maybe step agreement practice join I resource.', '2025-04-20 23:02:35.269274'),
(138, 'caseykimberly', 'wsutton', 'Already run manager course shoulder operation. Media test move impact live month language.
Up college its somebody else.
Reflect five yeah but.', '2025-03-18 11:52:12.067437'),
(139, 'ogibbs', 'lucaschristine', 'Whose five marriage have nature care institution. Pick student manager expert movement race moment catch.
Once stuff yeah feeling.', '2025-02-21 08:44:50.378122'),
(140, 'lucaschristine', 'linjade', 'Audience poor group woman development read glass. Toward cause next if similar again. Customer resource actually only knowledge space.', '2025-01-05 11:54:32.748297'),
(141, 'arobinson', 'bsimmons', 'To cover tonight you fact together safe hospital. Decade everyone him protect affect fish relationship seem.', '2025-02-20 10:27:42.100548'),
(142, 'daniel34', 'doris44', 'Message Congress great century.
Whose detail whatever various official quickly often. Edge rest between girl first whom smile Mrs. I month image respond water project affect.', '2025-02-21 06:22:53.037293'),
(143, 'fordthomas', 'daniel34', 'Report trip structure statement move. Really seat deep side. Make senior far ahead low his total.', '2025-02-19 01:56:18.708092'),
(144, 'qrodriguez', 'ggutierrez', 'Next lose third form attention eight rich. Investment owner everything start behind realize.', '2025-04-04 05:50:49.318539'),
(145, 'sphillips', 'trocha', 'Defense Mr particularly table technology compare. Then radio cause parent sense parent specific.
Lose war left bar. About audience company throw. Half effort off want turn sit. Plan get more.', '2025-04-05 02:18:56.133611'),
(146, 'derek75', 'jessewood', 'Mention radio employee design rate require people. Dark operation early action last.
Their fear short. Model speak along. Total present full think.', '2025-03-06 00:15:32.169972'),
(147, 'melindajackson', 'trocha', 'Hard environmental pass. Return better simply agreement fight above democratic white.
Child marriage at above capital natural price. Eye ready issue boy research. Drop challenge hot operation.', '2025-03-05 11:26:10.168210'),
(148, 'bpage', 'macdonaldallison', 'Reveal rest quite believe attention itself fast.
Us college kitchen yourself southern gun. Population care list rock again throw. Example indeed establish bed by.', '2025-02-07 06:10:41.401927'),
(149, 'friedmancindy', 'snyderalexa', 'Technology everybody must better guy reality same. Determine standard seek risk always her tell. Character appear design international lot agent similar. Create read meet bank.', '2025-04-29 18:11:23.518677'),
(150, 'justin45', 'vburns', 'Onto world thing animal by. We mean onto remember road tonight.
Line American family expert. Agreement money management by.', '2025-01-26 00:12:08.752492');

INSERT INTO ShopCategories (shop_id, category_id) VALUES
(12, 1),
(3, 4),
(12, 10),
(3, 7),
(3, 10),
(17, 9),
(11, 2),
(10, 9),
(2, 8),
(20, 4),
(7, 10),
(6, 8),
(12, 9),
(5, 3),
(5, 9),
(17, 8),
(8, 8),
(15, 4),
(2, 10),
(16, 9),
(16, 3),
(14, 2),
(14, 5),
(4, 10),
(9, 6),
(1, 1),
(11, 9),
(13, 6),
(6, 3),
(7, 8);

INSERT INTO ShopProducts (shop_id, product_id) VALUES
(6, 'P1028'),
(7, 'P1019'),
(1, 'P1022'),
(10, 'P1030'),
(2, 'P1044'),
(4, 'P1027'),
(2, 'P1012'),
(6, 'P1043'),
(13, 'P1016'),
(9, 'P1036'),
(15, 'P1045'),
(14, 'P1020'),
(3, 'P1017'),
(17, 'P1045'),
(7, 'P1008'),
(14, 'P1021'),
(9, 'P1008'),
(6, 'P1020'),
(5, 'P1039'),
(3, 'P1049'),
(16, 'P1046'),
(20, 'P1021'),
(16, 'P1036'),
(14, 'P1047'),
(8, 'P1048'),
(15, 'P1037'),
(19, 'P1038'),
(12, 'P1017'),
(20, 'P1023'),
(5, 'P1037'),
(2, 'P1029'),
(12, 'P1026'),
(6, 'P1029'),
(6, 'P1017'),
(8, 'P1004'),
(8, 'P1017'),
(17, 'P1043'),
(17, 'P1033'),
(8, 'P1016'),
(1, 'P1043'),
(4, 'P1024'),
(6, 'P1036'),
(11, 'P1005'),
(19, 'P1046'),
(7, 'P1040'),
(2, 'P1035'),
(7, 'P1048'),
(10, 'P1007'),
(19, 'P1049'),
(17, 'P1010'),
(16, 'P1044'),
(9, 'P1040'),
(2, 'P1025'),
(14, 'P1006'),
(7, 'P1033'),
(6, 'P1025'),
(17, 'P1009'),
(17, 'P1015'),
(19, 'P1011'),
(2, 'P1008'),
(9, 'P1043'),
(15, 'P1041'),
(10, 'P1027'),
(20, 'P1003'),
(1, 'P1048'),
(12, 'P1023'),
(17, 'P1042'),
(12, 'P1027'),
(15, 'P1026'),
(9, 'P1010'),
(20, 'P1030'),
(15, 'P1000'),
(17, 'P1024'),
(8, 'P1007'),
(5, 'P1031'),
(18, 'P1004'),
(10, 'P1003'),
(12, 'P1006'),
(7, 'P1041'),
(7, 'P1042');

INSERT INTO Orders (id, user_username, total_price, shipping_method, payment_method, payment_time, registration_time, status, tracking_code, buyer_note) VALUES
(1, 'vburns', 617.57, 'Express', 'PayPal', '2025-03-10 02:02:18.250814', '2025-04-24 22:34:27.890332', 'Shipped', '2b746925-0136-43e0-b8c6-046a4bb32a65', 'Government just how subject ahead.'),
(2, 'xcrane', 531.04, 'Standard', 'COD', '2025-01-28 15:04:57.899253', '2025-01-21 17:30:31.960440', 'Shipped', 'c34f86e6-a7fb-460a-a880-74895bbacf07', 'First language sister.'),
(3, 'macdonaldallison', 534.88, 'Express', 'PayPal', '2025-02-23 21:41:21.878591', '2025-01-15 16:00:46.878037', 'Pending', '815386e8-b7bd-4c53-876e-bca72494e062', 'Look power trouble do none.'),
(4, 'burnsjessica', 101.9, 'Standard', 'COD', '2025-03-27 16:22:09.281902', '2025-01-25 22:52:37.283662', 'Pending', '88334211-ee0a-4b90-a872-9d8c4c0e4231', 'Air question now.'),
(5, 'burnsjessica', 927.83, 'Courier', 'PayPal', '2025-02-16 14:04:36.128659', '2025-02-23 16:09:29.589440', 'Delivered', 'ddc6af93-be40-4ebc-aa8d-d7294d6e5ab4', 'Ten appear week play scene.'),
(6, 'cnewton', 769.54, 'Courier', 'Credit Card', '2025-02-21 20:46:26.971756', '2025-03-12 02:21:24.473455', 'Shipped', '07320123-2807-4560-a114-bd886fce0c40', 'President page that painting affect apply last officer.'),
(7, 'david65', 284.17, 'Standard', 'PayPal', '2025-03-31 07:25:26.953353', '2025-02-17 00:25:14.560987', 'Pending', '4237cc43-3771-4dc3-a9b8-cf2855fdd038', 'Finally full myself option ask teacher play.'),
(8, 'leerobert', 935.68, 'Standard', 'COD', '2025-02-02 13:54:19.909198', '2025-02-09 14:47:35.757658', 'Pending', '54c0cd19-6ff0-41ca-8de3-15f6560ecc90', 'Particular realize act project instead.'),
(9, 'mgriffin', 995.05, 'Standard', 'PayPal', '2025-04-24 14:38:14.731625', '2025-02-07 09:24:03.558581', 'Delivered', '69884375-614b-4c7a-a6e5-e1bf0ecddee2', 'Within letter garden south never image model.'),
(10, 'mgriffin', 147.37, 'Standard', 'Credit Card', '2025-02-19 09:35:25.996055', '2025-01-11 19:33:32.952653', 'Pending', 'b7fae0d1-a78e-4555-82fc-88cde58a98c8', 'Study so build tonight.'),
(11, 'salazargregory', 974.61, 'Standard', 'COD', '2025-02-21 07:31:01.953138', '2025-01-31 15:15:06.510811', 'Delivered', '1ea0eb27-2ed2-446f-8090-6a03f35be283', 'Age dream later under dream.'),
(12, 'cnewton', 474.24, 'Standard', 'PayPal', '2025-04-22 17:30:35.302245', '2025-04-04 10:35:25.965761', 'Shipped', 'a82cad7c-3573-4370-beb4-a2fbabf44042', 'Ok machine lawyer character effect serious interview.'),
(13, 'leerobert', 442.91, 'Express', 'Credit Card', '2025-04-24 07:12:54.793183', '2025-04-01 09:39:09.078905', 'Shipped', 'd4c57320-d8bb-4cc5-a538-1d8b298dfb04', 'Argue west just perhaps marriage similar theory.'),
(14, 'justin45', 854.51, 'Express', 'COD', '2025-03-14 23:40:09.112689', '2025-03-13 08:53:02.021611', 'Shipped', '4e562893-401c-496e-b3ec-b01c7c98e086', 'Make voice attention.'),
(15, 'david65', 319.57, 'Express', 'COD', '2025-01-17 20:03:51.537397', '2025-02-18 05:53:13.493389', 'Pending', 'cca90f68-ca6a-4bf1-a286-2092a05350e0', 'Wife hot simply thought college must.'),
(16, 'egraham', 717.93, 'Express', 'COD', '2025-01-01 16:52:02.260021', '2025-04-18 20:16:01.896458', 'Delivered', '22cee53d-7bb9-47d0-87fd-0582e0e9bcb9', 'Enjoy political dream money stage yard many.'),
(17, 'john73', 233.06, 'Courier', 'Credit Card', '2025-04-26 11:33:36.636260', '2025-01-28 00:51:03.187809', 'Delivered', '2d3ed7cc-fb5b-4d94-9cbf-97d18105f019', 'To ago safe allow.'),
(18, 'mendozaannette', 849.41, 'Express', 'PayPal', '2025-02-09 04:40:39.027375', '2025-03-20 10:34:34.527698', 'Pending', '47cbde9b-5cc4-4d5d-9df3-770893e9c62d', 'Attack big trade near it.'),
(19, 'tlong', 683.99, 'Express', 'PayPal', '2025-04-20 16:27:38.305703', '2025-04-08 20:17:48.200950', 'Pending', '0296b963-6c1d-4dd8-b30d-d9a39e1de545', 'Service edge entire vote few thought surface.'),
(20, 'melissamitchell', 940.39, 'Courier', 'Credit Card', '2025-01-30 02:50:13.169344', '2025-02-06 14:44:11.029540', 'Pending', 'ae430a0c-eec6-4034-92b6-bd4d5e593628', 'Because yes international out service politics but.'),
(21, 'brianna36', 560.14, 'Express', 'PayPal', '2025-01-26 07:35:41.893211', '2025-01-01 20:51:06.660718', 'Pending', '4cef899d-664d-441a-91a8-29bd15e1bb40', 'Only across black year couple get participant.'),
(22, 'melissamitchell', 227.81, 'Express', 'PayPal', '2025-02-15 01:30:57.359621', '2025-02-26 00:05:39.456488', 'Delivered', 'ed357bef-f0d7-4e2f-8779-d7f6deaa6903', 'Upon through others exist professor shake budget bill.'),
(23, 'rojasstephanie', 103.31, 'Courier', 'COD', '2025-04-20 14:32:19.880009', '2025-02-26 02:08:25.421563', 'Shipped', '7fca3e36-aa59-4834-966c-1fce24d2d0be', 'Foot audience arm interview picture weight summer benefit.'),
(24, 'svalenzuela', 321.25, 'Standard', 'PayPal', '2025-01-14 20:39:17.412075', '2025-01-03 10:48:38.004852', 'Delivered', '1768044a-2816-4166-95a1-1ccaa005baa5', 'Page religious fine with.'),
(25, 'lucaschristine', 135.56, 'Courier', 'PayPal', '2025-04-23 23:30:19.147941', '2025-01-16 18:37:02.728687', 'Shipped', 'bee1d041-6da7-4c5a-b6d9-e8d0fcdce26f', 'Result take media hear participant speak.'),
(26, 'burnsjessica', 866.7, 'Standard', 'Credit Card', '2025-02-18 06:23:11.580538', '2025-02-10 12:48:11.382610', 'Pending', '675401a7-3ef8-4286-bce5-76acd266d84e', 'Remain improve air toward.'),
(27, 'bpage', 159.44, 'Express', 'Credit Card', '2025-01-05 15:58:32.466369', '2025-03-14 16:25:32.594536', 'Shipped', '082e36bf-6360-434d-b5bb-c71bec3a1191', 'Remember final fill eye statement must eat.'),
(28, 'melissalester', 239.36, 'Standard', 'Credit Card', '2025-01-10 07:38:05.145673', '2025-02-01 05:11:35.827996', 'Pending', '414eaa34-f342-4c10-b982-8a40d4b8e461', 'Better stuff religious factor own window.'),
(29, 'clopez', 24.19, 'Express', 'PayPal', '2025-01-10 08:28:43.453656', '2025-04-21 15:55:30.574842', 'Shipped', 'f9e0fd95-8e59-4691-87cc-f9743661300e', 'Economy technology couple company.'),
(30, 'bjohnson', 841.88, 'Express', 'COD', '2025-01-11 02:15:47.605537', '2025-02-19 15:44:41.042159', 'Shipped', 'eaef3580-7294-4ac9-94dd-1c23b62806d9', 'Check apply watch action get.'),
(31, 'trocha', 528.15, 'Courier', 'PayPal', '2025-03-24 10:23:06.234522', '2025-03-22 03:58:12.571452', 'Pending', 'ca47da21-36aa-40b1-b36b-bad75bfc7b32', 'Boy know it.'),
(32, 'angelasmith', 589.52, 'Express', 'Credit Card', '2025-02-12 08:29:42.965361', '2025-04-23 00:09:48.757553', 'Pending', '6be3d2a6-08bc-4f8f-9b3c-fb5d3a2d2d83', 'Song citizen above set thing.'),
(33, 'bpage', 926.01, 'Standard', 'PayPal', '2025-01-02 11:03:36.329394', '2025-03-03 09:07:42.363684', 'Delivered', '0a4d1ae5-5dc6-414f-b7b6-5085d1d8ff74', 'Might drive get season.'),
(34, 'moonlisa', 206.87, 'Express', 'PayPal', '2025-04-04 03:51:02.334007', '2025-04-12 16:54:45.060272', 'Delivered', '727ab500-544b-4c5d-853d-1b0a2faf078f', 'Blue your how forward guy type past.'),
(35, 'zcrawford', 814.23, 'Courier', 'Credit Card', '2025-03-12 21:57:34.805625', '2025-03-11 18:27:59.465739', 'Pending', 'cec33a4d-0211-4112-8431-e9985561f869', 'Without director by age teach president.'),
(36, 'laura25', 978.74, 'Express', 'PayPal', '2025-04-10 09:33:51.475251', '2025-01-25 09:23:57.749574', 'Delivered', '26d5ab7f-e391-449b-ac02-b5de2b5aaafc', 'Move less certain tree financial.'),
(37, 'clopez', 378.1, 'Courier', 'Credit Card', '2025-01-14 22:40:43.558640', '2025-03-24 22:02:07.938713', 'Delivered', '09a74490-7538-43e3-8383-ea8cebdf6b3f', 'Term identify seat both enough beyond admit performance.'),
(38, 'salazargregory', 741.55, 'Standard', 'COD', '2025-03-08 14:35:19.927511', '2025-02-23 20:37:07.334467', 'Shipped', 'e10e2a5f-c725-4ca6-977e-9bb668486334', 'Defense as tend blue.'),
(39, 'tammysmith', 197.85, 'Express', 'PayPal', '2025-01-07 11:23:44.846241', '2025-02-28 06:01:10.382801', 'Pending', '26896727-07f1-47c2-a1ef-a21d4536f946', 'Least in perform clearly wear position rock top.'),
(40, 'vgreen', 801.51, 'Express', 'COD', '2025-04-18 08:26:37.329400', '2025-01-09 14:53:54.693378', 'Delivered', 'a7a89518-0812-4030-be96-93f72c054583', 'Bed that dream daughter peace such trip.'),
(41, 'staceyoneill', 590.73, 'Standard', 'COD', '2025-04-14 23:56:48.194705', '2025-01-08 01:50:26.699059', 'Pending', '90bd2914-2372-46f2-ba5b-acd42a5a11ec', 'Bill just your two probably.'),
(42, 'eriley', 643.08, 'Courier', 'PayPal', '2025-02-19 08:00:12.077027', '2025-04-22 07:30:48.714087', 'Pending', 'a9980e77-db5d-40a2-9bae-5fd274698c12', 'Since other case institution level moment.'),
(43, 'bjohnson', 246.74, 'Express', 'PayPal', '2025-02-02 07:04:37.671229', '2025-04-15 12:53:25.505549', 'Delivered', 'e531bd47-7e6d-4bd7-a065-1c6b10be3cc6', 'Member personal put seem mind kitchen poor space.'),
(44, 'ogibbs', 613.66, 'Express', 'COD', '2025-02-12 18:09:23.004205', '2025-04-08 10:36:57.703211', 'Shipped', '3d1e78a1-db00-4c7b-a8f6-df1ee10092f5', 'My pay nation least fall fly.'),
(45, 'jonathanmorris', 215.01, 'Courier', 'Credit Card', '2025-02-03 07:42:50.105075', '2025-04-27 01:50:10.297415', 'Delivered', '59c2ec89-8347-495a-89cd-833bba539bdf', 'Face individual ever cut real let.'),
(46, 'fordthomas', 653.3, 'Courier', 'COD', '2025-03-11 01:49:43.662003', '2025-03-15 01:07:16.160667', 'Delivered', '33ec50fd-999b-4dac-8685-d7477f49fcd0', 'Almost everything great price fear want run.'),
(47, 'colton14', 503.68, 'Express', 'PayPal', '2025-01-15 22:28:01.002656', '2025-01-17 14:12:39.815567', 'Pending', '9567dd53-b31b-4912-b168-f8c73253ac45', 'Western section much source.'),
(48, 'rojasstephanie', 408.48, 'Standard', 'PayPal', '2025-02-20 23:47:14.835483', '2025-04-01 21:42:15.970524', 'Pending', 'a4433f72-62b8-495d-a037-893381bb895c', 'Natural ball international most and.'),
(49, 'wallacejacob', 495.22, 'Express', 'PayPal', '2025-03-07 14:23:18.945886', '2025-01-10 16:20:02.901681', 'Shipped', '290256f5-3592-4a94-b3c0-ddf477fed5b8', 'Gun himself action because section current.'),
(50, 'eriley', 942.27, 'Standard', 'PayPal', '2025-03-08 22:20:29.565003', '2025-02-01 12:24:30.087613', 'Pending', '8efd2416-3f31-476b-85ed-edc98230bfa1', 'When film each research.'),
(51, 'doris44', 822.05, 'Standard', 'Credit Card', '2025-02-23 15:47:59.331600', '2025-04-19 09:13:45.677175', 'Pending', '437b9e19-b3a0-492c-982b-04b167d5a3b8', 'Section effort anything she commercial you watch early.'),
(52, 'ariaskrystal', 660.13, 'Express', 'Credit Card', '2025-01-14 23:12:48.900347', '2025-01-12 04:30:24.700257', 'Shipped', 'a8d22070-bc7e-4d7b-a810-d14547cb0502', 'He require you game write heavy blue.'),
(53, 'caseykimberly', 435.56, 'Courier', 'COD', '2025-02-04 17:00:12.007082', '2025-04-16 05:03:33.305918', 'Shipped', '0a0698a6-10af-400b-9f25-7cb31db02485', 'Fish argue manage save college.'),
(54, 'friedmancindy', 507.84, 'Courier', 'PayPal', '2025-02-04 18:29:39.100570', '2025-04-15 06:53:33.595503', 'Delivered', 'd3c045d5-ad48-4f7f-8e7d-50d96fddf566', 'Number people magazine team know.'),
(55, 'lucaschristine', 147.55, 'Standard', 'COD', '2025-02-07 02:43:42.941438', '2025-02-07 13:45:43.763152', 'Pending', 'db1a5d3f-5f39-44e7-9904-9f1973d8a32e', 'Third full couple strong.'),
(56, 'sbarnes', 855.63, 'Standard', 'Credit Card', '2025-01-05 01:46:43.399666', '2025-04-18 10:30:54.878703', 'Delivered', '61bf1899-63cd-4ce8-aaa3-c39a26bfda7b', 'Any lawyer meet once.'),
(57, 'sphillips', 466.69, 'Standard', 'PayPal', '2025-01-17 07:14:23.666041', '2025-04-23 07:12:06.239066', 'Delivered', '0e3f6a9b-8648-4a30-921f-8732bf47e036', 'Back whose out glass one.'),
(58, 'melissalester', 65.21, 'Express', 'PayPal', '2025-02-19 07:04:25.373409', '2025-02-13 10:05:32.671928', 'Delivered', '378919b3-059c-4064-aa1a-c1f88fe0dc24', 'Quality head data question positive must be.'),
(59, 'hhawkins', 444.24, 'Courier', 'COD', '2025-03-25 05:35:40.606618', '2025-02-22 03:44:56.365941', 'Delivered', '0a7d887e-738b-44fc-9bc6-0afd9f425dad', 'Study face young great report several.'),
(60, 'bauerchristopher', 45.29, 'Courier', 'COD', '2025-02-07 01:15:25.227320', '2025-03-17 12:12:52.740395', 'Pending', '73047d2b-7ef5-44fe-bbe2-f91968912c87', 'Analysis study happen direction.'),
(61, 'brianna36', 472.62, 'Standard', 'Credit Card', '2025-02-17 12:53:25.232009', '2025-03-26 12:40:19.190234', 'Pending', 'b99661b2-683f-4100-a8a4-e1b8b65128e8', 'Only change both.'),
(62, 'colemanbrittany', 82.05, 'Courier', 'PayPal', '2025-01-14 16:15:51.775685', '2025-02-04 12:33:28.598726', 'Shipped', '0ad1721d-efa7-4060-a8c9-27f4bca860c1', 'Help purpose shake high cost support.'),
(63, 'chelsea28', 621.96, 'Standard', 'Credit Card', '2025-02-28 22:02:55.070346', '2025-01-10 01:00:31.385921', 'Pending', '99bf23b2-da2d-4e2e-993c-224aba20aa7f', 'Marriage around hand individual office among.'),
(64, 'joseph57', 732.26, 'Courier', 'Credit Card', '2025-04-07 19:32:09.465616', '2025-03-02 23:26:25.317806', 'Shipped', 'c4e0699c-3b41-4e12-b699-cce2f55443bf', 'Together once possible investment industry tax.'),
(65, 'jessewood', 83.64, 'Courier', 'Credit Card', '2025-04-20 06:00:47.846774', '2025-01-09 23:27:29.278937', 'Shipped', 'bf14f376-da03-4db8-add2-d4b8e1dcec55', 'Young statement relate really response note eight.'),
(66, 'powersbryan', 650.58, 'Standard', 'PayPal', '2025-03-24 03:46:50.669296', '2025-01-16 02:12:36.184895', 'Pending', '0378b622-4790-4af6-b39f-88054e889229', 'Him of hope size painting.'),
(67, 'angelasmith', 658.97, 'Courier', 'COD', '2025-02-19 20:40:24.280156', '2025-01-18 08:35:00.226425', 'Pending', '8e478662-58c1-4f3b-8840-6df899f26244', 'Throughout improve scene focus own ten.'),
(68, 'tammysmith', 85.34, 'Courier', 'PayPal', '2025-03-11 20:45:38.094676', '2025-04-17 16:41:11.351866', 'Pending', '20e4dc46-ad7c-4c7e-9a9f-9fc2e605cbcd', 'After relationship feeling compare I animal who.'),
(69, 'friedmancindy', 452.83, 'Standard', 'PayPal', '2025-01-29 20:21:52.473826', '2025-01-31 22:47:00.077522', 'Delivered', '65fad14d-786f-49bb-9811-cc7a631c4ca9', 'Deep minute data long government wait traditional.'),
(70, 'danielle74', 633.51, 'Standard', 'COD', '2025-03-16 12:00:32.107282', '2025-02-16 10:22:03.631999', 'Shipped', 'f28fba4b-3764-464a-b7d3-b67d627e4e5c', 'Lose none raise area discussion picture plan.'),
(71, 'jerry25', 306.03, 'Courier', 'PayPal', '2025-01-18 13:42:29.139793', '2025-02-15 08:00:07.483654', 'Delivered', 'd020ee15-f335-43ea-83ff-2423aa497f54', 'Federal put campaign contain hold account defense.'),
(72, 'sphillips', 49.14, 'Standard', 'COD', '2025-01-20 09:07:48.285358', '2025-01-01 05:31:37.342959', 'Delivered', '568b9c5c-1745-478d-a74d-7a92ba3ac47c', 'Dream term case minute seven.'),
(73, 'hhawkins', 311.43, 'Standard', 'Credit Card', '2025-01-11 23:00:48.875635', '2025-02-13 22:01:34.786707', 'Pending', '6fe9176e-e25f-4e5a-8162-3ce861a467e1', 'Race family view into scientist.'),
(74, 'tlong', 455.5, 'Standard', 'Credit Card', '2025-03-11 07:55:12.545537', '2025-02-11 17:00:57.034636', 'Pending', '48869c36-8309-45e0-83ea-05352af433de', 'Drive customer market popular goal.'),
(75, 'egraham', 909.42, 'Express', 'COD', '2025-04-27 23:21:11.589743', '2025-04-17 20:55:55.715769', 'Shipped', 'b7d3c5fc-26dd-40eb-b7f7-9585e48670b9', 'Loss make economic act why thing.'),
(76, 'danielle74', 33.53, 'Courier', 'PayPal', '2025-03-03 06:02:59.074474', '2025-03-02 13:58:45.248423', 'Delivered', '628a69a4-f44b-401c-b9db-764f94f29026', 'Sign on second physical significant.'),
(77, 'bjohnson', 642.11, 'Standard', 'COD', '2025-03-16 04:47:41.238627', '2025-03-30 04:24:07.537931', 'Shipped', '81ef9cff-44be-45bf-8fc5-b2ff4c4f00b5', 'Compare lay two project.'),
(78, 'mnelson', 93.2, 'Express', 'COD', '2025-02-26 22:03:47.556251', '2025-01-13 01:49:19.945664', 'Shipped', '19f8a213-d94f-4faa-b93a-54400ca86b04', 'Enter administration figure time rest since president star.'),
(79, 'vburns', 405.17, 'Express', 'PayPal', '2025-03-16 09:49:02.243818', '2025-01-21 18:48:15.013108', 'Shipped', '5d3c85ec-8af9-4cce-a087-7570fc6d4e8f', 'Just point increase reflect dream.'),
(80, 'melissalester', 664.68, 'Standard', 'PayPal', '2025-03-06 06:52:01.725935', '2025-02-01 12:07:55.372992', 'Shipped', '6166608c-c3d6-4ddc-9c21-25576dcff6b0', 'Protect here land hour.');

INSERT INTO OrderProducts (order_id, product_id, quantity) VALUES
(74, 'P1030', 2),
(9, 'P1004', 1),
(23, 'P1003', 5),
(39, 'P1008', 5),
(79, 'P1017', 4),
(18, 'P1046', 5),
(77, 'P1018', 1),
(25, 'P1003', 5),
(9, 'P1021', 5),
(6, 'P1044', 5),
(37, 'P1004', 1),
(53, 'P1039', 1),
(42, 'P1014', 3),
(22, 'P1049', 3),
(46, 'P1006', 5),
(1, 'P1004', 2),
(16, 'P1015', 5),
(6, 'P1014', 5),
(9, 'P1047', 1),
(4, 'P1014', 3),
(17, 'P1045', 5),
(19, 'P1014', 4),
(54, 'P1031', 4),
(57, 'P1015', 4),
(53, 'P1027', 5),
(47, 'P1037', 4),
(14, 'P1018', 4),
(58, 'P1018', 2),
(3, 'P1046', 5),
(59, 'P1015', 2),
(9, 'P1008', 1),
(46, 'P1040', 1),
(33, 'P1017', 3),
(4, 'P1040', 4),
(26, 'P1043', 5),
(51, 'P1003', 5),
(46, 'P1038', 4),
(57, 'P1038', 1),
(77, 'P1006', 1),
(68, 'P1046', 1),
(33, 'P1036', 3),
(49, 'P1030', 3),
(66, 'P1003', 3),
(48, 'P1026', 2),
(61, 'P1018', 2),
(10, 'P1021', 3),
(5, 'P1043', 4),
(28, 'P1013', 2),
(10, 'P1046', 1),
(50, 'P1026', 5),
(50, 'P1049', 1),
(38, 'P1043', 5),
(54, 'P1045', 1),
(5, 'P1013', 2),
(34, 'P1003', 2),
(25, 'P1024', 5),
(37, 'P1028', 4),
(15, 'P1016', 1),
(66, 'P1033', 4),
(40, 'P1036', 5),
(70, 'P1004', 3),
(56, 'P1034', 3),
(5, 'P1040', 2),
(79, 'P1010', 3),
(19, 'P1019', 5),
(37, 'P1014', 2),
(50, 'P1045', 5),
(49, 'P1004', 1),
(62, 'P1038', 4),
(33, 'P1027', 5),
(64, 'P1042', 4),
(35, 'P1048', 1),
(36, 'P1002', 1),
(51, 'P1045', 5),
(15, 'P1008', 3),
(45, 'P1010', 2),
(69, 'P1005', 5),
(39, 'P1001', 3),
(31, 'P1013', 4),
(71, 'P1003', 1),
(51, 'P1035', 2),
(69, 'P1034', 4),
(52, 'P1001', 2),
(47, 'P1025', 3),
(25, 'P1035', 4),
(66, 'P1002', 3),
(28, 'P1021', 4),
(14, 'P1048', 1),
(75, 'P1010', 5),
(4, 'P1045', 2),
(40, 'P1028', 1),
(62, 'P1008', 4),
(32, 'P1002', 3),
(42, 'P1023', 3),
(32, 'P1036', 2),
(16, 'P1043', 3),
(29, 'P1044', 5),
(12, 'P1006', 1),
(21, 'P1007', 1),
(15, 'P1032', 2);

INSERT INTO ProductReviews (id, user_username, product_id, rating, review_text, review_date) VALUES
(1, 'sbarnes', 'P1023', 4, 'Add could large a likely audience. Born put around.', '2025-01-03 21:45:59.857093'),
(2, 'erika75', 'P1011', 4, 'Walk interview Mr suggest person show avoid sea. Stuff year turn strong. Anyone military develop.', '2025-04-13 17:36:20.179511'),
(3, 'ogibbs', 'P1015', 1, 'Choose manage behavior factor. Deal perhaps family above. Hit friend pass strong water language.', '2025-01-27 19:05:09.760757'),
(4, 'egraham', 'P1045', 3, 'Opportunity walk safe threat suffer. New party go citizen movement perform rich letter.', '2025-04-23 21:44:42.304321'),
(5, 'qrodriguez', 'P1032', 1, 'Past same thus current. Special far statement fish.', '2025-02-09 20:57:23.325305'),
(6, 'ugonzalez', 'P1040', 1, 'Skin strong performance try similar. Who must civil industry respond mention.', '2025-02-24 10:07:13.348111'),
(7, 'ggutierrez', 'P1047', 4, 'Table glass anyone model. Single such computer today election group.', '2025-04-11 19:09:22.388460'),
(8, 'trocha', 'P1039', 2, 'Example system great though. Baby bit speech officer boy. Challenge fall north year bit by explain.', '2025-02-21 21:13:29.771698'),
(9, 'croberts', 'P1030', 2, 'Either technology company check. Lawyer create seek course. Ever dog morning.', '2025-04-05 16:58:57.860885'),
(10, 'bensondavid', 'P1003', 4, 'Drop democratic subject able. My add individual factor.', '2025-04-02 07:49:04.262568'),
(11, 'staceyoneill', 'P1026', 1, 'Forward fight him issue food. Speech service worry tax company possible.', '2025-04-20 21:58:08.626888'),
(12, 'friedmancindy', 'P1002', 3, 'Energy social entire. Beyond senior tree wife.
Class event represent majority.', '2025-03-19 07:13:23.859941'),
(13, 'ccalhoun', 'P1038', 4, 'Determine case pretty argue center. Development second hospital somebody.', '2025-04-28 13:58:03.006313'),
(14, 'derek75', 'P1045', 3, 'Eat dark successful leader peace move customer. Back sister least brother arrive design though.', '2025-04-27 10:23:57.956914'),
(15, 'speterson', 'P1005', 1, 'Wear program affect section hand mission avoid.', '2025-02-05 07:34:34.378041'),
(16, 'caseykimberly', 'P1036', 2, 'Simply especially friend ball. Speak old back. High rich any arm experience.', '2025-02-14 22:07:19.811189'),
(17, 'melissalester', 'P1049', 3, 'Machine shoulder win. Interest would discuss after.', '2025-01-17 02:29:39.096825'),
(18, 'bpage', 'P1048', 4, 'Total deep audience traditional rate line experience successful. Hand indeed home suffer bring.', '2025-02-12 10:02:44.965645'),
(19, 'patrickharvey', 'P1044', 4, 'Traditional speak set road believe interview sister. Fine expect player always take husband.', '2025-02-26 06:32:21.829103'),
(20, 'eriley', 'P1022', 1, 'Or project arrive discussion term. Father pattern its approach. Cultural society whose.', '2025-01-10 17:29:06.837646'),
(21, 'colemanbrittany', 'P1039', 5, 'Line society rule history. Special spend car add include election.', '2025-03-20 23:05:22.606425'),
(22, 'derek75', 'P1041', 3, 'Very student behind people surface able forward.', '2025-04-13 05:29:34.123406'),
(23, 'lucaschristine', 'P1005', 1, 'Common for rule apply most. Represent bag score which.', '2025-04-28 06:22:30.915285'),
(24, 'lucaschristine', 'P1004', 5, 'Because example bad win in total consider. Up by anything leave information purpose growth.', '2025-02-19 16:46:13.353516'),
(25, 'mgriffin', 'P1010', 3, 'Watch just on hope coach speech. Popular look factor.', '2025-04-04 15:47:26.638623'),
(26, 'morrisonsara', 'P1022', 1, 'Film good however. Half reveal growth argue tough.', '2025-02-09 08:51:50.057400'),
(27, 'twilson', 'P1037', 5, 'Much test mission list back. Help become be ground activity. Visit head court source tell.', '2025-01-26 13:16:18.581281'),
(28, 'daniel74', 'P1035', 5, 'Old stay stuff treatment cover story mouth. Guess general risk myself health.', '2025-04-17 10:28:22.125402'),
(29, 'william68', 'P1022', 2, 'Large also garden at structure nice. Bill south decide mission. Price cause court him surface.', '2025-02-07 07:17:41.634904'),
(30, 'cnewton', 'P1020', 2, 'Research human of summer. Writer surface its story matter try news.', '2025-04-18 20:38:44.481793'),
(31, 'melindajackson', 'P1024', 2, 'Course should card eat tree. Back little exactly natural physical argue one.', '2025-02-23 08:53:12.157420'),
(32, 'melindajackson', 'P1041', 3, 'Radio attorney radio work discuss catch. Doctor stop us economy rich trouble.', '2025-02-01 02:55:07.456643'),
(33, 'elizabethperry', 'P1031', 5, 'Over cultural quite opportunity. Laugh however store check section.', '2025-01-30 14:05:09.052677'),
(34, 'wallacejacob', 'P1017', 1, 'Industry prevent boy design range woman.', '2025-02-16 19:32:06.252432'),
(35, 'teresa90', 'P1038', 2, 'Recently consider quickly part. Size management hotel together.', '2025-02-27 11:07:56.787545'),
(36, 'staceyoneill', 'P1005', 4, 'Than agree remember such approach ago style. Outside Mr likely.', '2025-03-17 14:50:30.585872'),
(37, 'roneill', 'P1049', 1, 'Court medical fear base cold know check leave. Natural less your race run and.', '2025-04-25 14:05:39.282150'),
(38, 'chelsea28', 'P1044', 2, 'Smile drive drop service teacher. Again ground learn stay.', '2025-03-09 19:36:24.881717'),
(39, 'elizabethperry', 'P1019', 1, 'My into last firm as recent. Source evidence those leave.', '2025-04-02 09:32:19.625090'),
(40, 'davenportjessica', 'P1031', 5, 'Without common example. Already not until thought. Computer own Mr program share.', '2025-04-27 08:09:37.157942'),
(41, 'justin38', 'P1001', 2, 'Of big sign work race my reduce. Somebody operation despite. Easy machine respond task.', '2025-04-28 04:58:54.227355'),
(42, 'sbarnes', 'P1026', 2, 'Economic near it nature officer travel anything. Build show policy green.', '2025-02-09 10:14:39.044469'),
(43, 'jerry25', 'P1046', 3, 'Project executive peace. Stock book western service.
Add artist arm true market drive.', '2025-03-15 12:32:41.934999'),
(44, 'caseykimberly', 'P1046', 4, 'Serve nature safe doctor. Over follow market popular in reveal. Specific level miss travel open.', '2025-04-09 21:37:09.687497'),
(45, 'dustinwilson', 'P1034', 1, 'Bill foreign white blue politics.
Data yeah station me. Then look star century save stand.', '2025-03-25 10:45:33.024743'),
(46, 'justin38', 'P1000', 3, 'Surface property boy. Allow notice available final song.', '2025-01-03 14:36:16.172889'),
(47, 'fordthomas', 'P1006', 4, 'Huge training key choose executive.', '2025-02-15 05:12:17.102164'),
(48, 'matthewpearson', 'P1006', 4, 'Carry with benefit meeting per issue key. Plant wide owner. Into central each accept other eat.', '2025-04-15 00:37:03.582952'),
(49, 'ugonzalez', 'P1030', 2, 'Director action business class drive. Ready mention girl machine too by she should.', '2025-03-24 18:40:43.471158'),
(50, 'william68', 'P1015', 1, 'Clearly meeting lay little. Court election add. Network catch let when firm still.', '2025-03-31 06:44:33.807470'),
(51, 'fordthomas', 'P1024', 3, 'Ok include under realize nice.', '2025-02-12 14:00:55.920622'),
(52, 'bpage', 'P1004', 1, 'See take goal.', '2025-04-17 22:47:40.078866'),
(53, 'colton14', 'P1032', 3, 'Garden say friend phone treatment nearly age often. Main talk tend behavior.', '2025-02-09 10:00:49.305007'),
(54, 'sbarnes', 'P1048', 5, 'Purpose couple well source. Trouble return beyond.', '2025-03-21 21:26:22.150594'),
(55, 'leahandrade', 'P1034', 1, 'Serve police ball thus. Energy ball land around enough.', '2025-03-02 01:34:56.982439'),
(56, 'eriley', 'P1004', 2, 'She similar cause third. Citizen movie consider field country owner.', '2025-03-11 08:38:09.082906'),
(57, 'bauerchristopher', 'P1042', 3, 'Down skill sound soon let common along option. Step try lawyer paper if every force.', '2025-04-28 23:58:48.637024'),
(58, 'richardsjanet', 'P1013', 2, 'Republican notice none magazine hundred yet. Town power gun miss. Dog investment we voice tend.', '2025-03-17 02:39:06.178725'),
(59, 'tammysmith', 'P1009', 1, 'Region player lay mouth positive. Across organization worry any east hit.', '2025-02-01 11:21:00.118151'),
(60, 'twilson', 'P1003', 4, 'Account rise must single entire upon fly. Real various serve policy recent voice garden future.', '2025-04-08 18:01:59.220071'),
(61, 'caseykimberly', 'P1007', 3, 'Police determine hotel.
Worry part economy its whether opportunity.', '2025-02-22 10:18:42.599436'),
(62, 'hhawkins', 'P1031', 5, 'National girl personal. Somebody huge ok course the ever. Add skin next so else.', '2025-04-02 08:56:52.753432'),
(63, 'tjohnson', 'P1018', 3, 'Research me various finish certainly apply exist its. Week several enough reach enough own.', '2025-04-25 00:07:08.387464'),
(64, 'ariaskrystal', 'P1017', 2, 'Bag old face whatever.
Too myself street per just market quickly. Still control make add study.', '2025-01-26 11:17:00.897978'),
(65, 'cnewton', 'P1039', 2, 'Long instead might service heart market improve. Ahead today eye trial voice seem.', '2025-03-31 20:50:23.289799'),
(66, 'joseph57', 'P1014', 5, 'Girl how laugh no. Daughter person main long black place listen.', '2025-04-10 23:32:05.301618'),
(67, 'david65', 'P1007', 5, 'Fear official ball. Situation interesting catch fish both almost others.', '2025-03-03 11:51:30.125923'),
(68, 'sphillips', 'P1004', 1, 'Level though buy worry while indeed major.', '2025-04-10 17:22:28.491999'),
(69, 'macdonaldallison', 'P1041', 1, 'Everything paper natural. Series world civil example.', '2025-01-07 03:06:33.570532'),
(70, 'travis30', 'P1010', 3, 'Both natural allow own skill shake.', '2025-02-20 19:30:15.265622'),
(71, 'brianna36', 'P1036', 5, 'Authority beyond success office. Though all partner school affect. Card work discover subject.', '2025-03-01 05:02:10.763071'),
(72, 'bensondavid', 'P1040', 1, 'Color information report not space pay. Around provide know.
Wind partner bad.', '2025-03-07 04:01:09.570393'),
(73, 'deborahgalloway', 'P1045', 2, 'A where here occur. You green be natural phone position left store.', '2025-04-03 18:46:51.458506'),
(74, 'tammysmith', 'P1044', 1, 'On book how community. Environment spend one especially.', '2025-04-25 08:48:29.347814'),
(75, 'wbaker', 'P1014', 4, 'Red rock without economic. Computer get above Congress actually once skill near.', '2025-02-20 14:09:46.319565'),
(76, 'sphillips', 'P1002', 1, 'Full heart box small hospital probably must.
Admit rule truth line season key ever.', '2025-03-24 12:28:12.368955'),
(77, 'mnelson', 'P1010', 5, 'Upon either worry security. Still serious reality plant son laugh decade.', '2025-02-15 17:17:35.002373'),
(78, 'ccalhoun', 'P1021', 5, 'Job manager water white respond current study. Detail available with read window leg black.', '2025-01-28 09:49:48.852014'),
(79, 'deborahgalloway', 'P1029', 4, 'Sound now big wall. All rather decade everything town. Blood spend glass military answer able.', '2025-02-07 19:06:54.398670'),
(80, 'clopez', 'P1004', 3, 'Which small news manage. Mrs town beyond cold thought. Third piece present even reflect.', '2025-04-18 19:24:26.889198'),
(81, 'travis30', 'P1026', 1, 'Statement far course guy stand upon. Federal whole account.', '2025-04-26 00:35:21.542331'),
(82, 'vburns', 'P1009', 4, 'Pattern trip hand. As force skin event.', '2025-02-11 05:13:51.853516'),
(83, 'morrisonsara', 'P1032', 4, 'Read officer politics without teach. From human and term speech.', '2025-02-06 00:39:46.261772'),
(84, 'dustinwilson', 'P1027', 4, 'Edge town two huge different face. Everybody charge citizen miss manager officer.', '2025-01-22 12:27:29.741688'),
(85, 'jonathanmorris', 'P1030', 3, 'Kid action social. Guy free citizen decision leader. Top away American conference including film.', '2025-01-27 19:56:02.328675'),
(86, 'matthewpearson', 'P1032', 5, 'Relationship in collection protect security party public. Trial total subject fire trip.', '2025-03-31 09:07:25.532923'),
(87, 'angelasmith', 'P1031', 2, 'Environmental compare board while save national standard. Month about else ground campaign.', '2025-02-24 01:41:18.540658'),
(88, 'mgriffin', 'P1018', 3, 'Wind today walk sure bar. Blue win trouble fast watch.', '2025-04-28 21:14:15.785000'),
(89, 'svalenzuela', 'P1016', 4, 'Listen page best.', '2025-01-25 15:50:06.538348'),
(90, 'hhawkins', 'P1014', 2, 'Strategy science raise past tend performance. Stay authority east tough laugh town.', '2025-01-11 13:07:06.880030'),
(91, 'matthewpearson', 'P1018', 1, 'Run answer purpose million month huge indicate. Hot value her miss. Determine sure other.', '2025-01-14 06:36:09.945672'),
(92, 'xcrane', 'P1037', 4, 'Sound dream building thus feel. American white world along.', '2025-02-22 15:36:33.356886'),
(93, 'rangelamy', 'P1035', 4, 'Reveal scientist his show.
Respond professor wish stand personal whatever respond.', '2025-04-13 04:22:00.572151'),
(94, 'melissamorris', 'P1030', 2, 'Thought measure family coach development. Pull spring food view their.', '2025-02-17 23:14:33.486371'),
(95, 'davenportjessica', 'P1043', 5, 'Line budget research score. Knowledge yet to by someone development. However sure age production.', '2025-03-23 18:23:05.511724'),
(96, 'qrodriguez', 'P1040', 1, 'Since section same project. Task summer popular like. Nice book young look citizen.', '2025-01-15 23:54:23.615341'),
(97, 'chelsea28', 'P1043', 3, 'Wall agent call fear out. Task get class. Everybody class maintain only more hard.', '2025-03-21 22:09:28.719528'),
(98, 'leerobert', 'P1048', 3, 'Enter magazine part against region cultural. Note character kid ago power.', '2025-01-11 17:38:06.982094'),
(99, 'grantjames', 'P1045', 1, 'Chance true dinner teacher general feeling. Tell strong writer well.
Capital wrong project still.', '2025-04-18 16:18:43.549165'),
(100, 'xcrane', 'P1043', 1, 'Senior anything protect who push final leg.
First represent realize road walk.', '2025-03-26 17:03:30.464734');

SELECT setval('addresses_id_seq', (SELECT MAX(id) FROM Addresses));
SELECT setval('messages_id_seq', (SELECT MAX(id) FROM Messages));
SELECT setval('shops_id_seq', (SELECT MAX(id) FROM Shops));
SELECT setval('categories_id_seq', (SELECT MAX(id) FROM Categories));
SELECT setval('orders_id_seq', (SELECT MAX(id) FROM Orders));
SELECT setval('productreviews_id_seq', (SELECT MAX(id) FROM ProductReviews));

-- -----------------------------------------------------