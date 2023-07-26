CREATE DATABASE IF NOT EXISTS ClothingStore
CHARACTER SET utf8mb4
COLLATE	utf8mb4_unicode_ci;

USE ClothingStore;

-- create tables
CREATE TABLE Catagories (
	catagory_id				VARCHAR(10) PRIMARY KEY NOT NULL,
	catagory_name			VARCHAR(80),
	creation_date			TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
)
ENGINE=INNODB;

CREATE TABLE Products (
	product_id				VARCHAR(10) PRIMARY KEY NOT NULL,
	product_name			VARCHAR(80),
	brand_name				VARCHAR(40),
	base_price				FLOAT NOT NULL,
	creation_date			TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
)
ENGINE=INNODB;

CREATE TABLE Sizes (
	size_id					VARCHAR(10) PRIMARY KEY NOT NULL,
	size_code				VARCHAR(5),
	price_multiplier		FLOAT NOT NULL
)
ENGINE=INNODB;

CReate TABLE Colors (
	color_id				VARCHAR(10) PRIMARY KEY NOT NULL,
	color_code				VARCHAR(6),
	color_name				VARCHAR(30),
	price_multiplier		FLOAT NOT NULL
)
ENGINE=INNODB;

CREATE TABLE Items (
	item_id					VARCHAR(20) PRIMARY KEY NOT NULL,
	catagory_id				VARCHAR(10),
	product_id				VARCHAR(10) NOT NULL,
	size_id					VARCHAR(10),
	color_id				VARCHAR(10),
	creation_date			TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_catagory
    FOREIGN KEY (catagory_id)
		REFERENCES Catagories(catagory_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
	CONSTRAINT fk_product
	FOREIGN KEY (product_id)
		REFERENCES Products(product_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
	CONSTRAINT fk_size
	FOREIGN KEY (size_id)
		REFERENCES Sizes(size_id)
			ON UPDATE CASCADE
            ON DELETE CASCADE,
	CONSTRAINT fk_color
    FOREIGN KEY (color_id)
		REFERENCES Colors(color_id)
			ON UPDATE CASCADE
            ON DELETE CASCADE
)
ENGINE=INNODB;

-- creating "Register" view
CREATE VIEW Register AS
	SELECT
		catagory_name AS 'Catagory',
		brand_name AS 'Brand',
		product_name 'Product',
		FORMAT(SUM(base_price + base_price * s.price_multiplier + base_price * col.price_multiplier), 'c2') AS 'Price',
		size_code AS 'Size',
		color_name AS 'Color'
	FROM
		Items as i
			LEFT JOIN Catagories AS cat ON i.catagory_id = cat.catagory_id
			LEFT JOIN Products AS p ON i.product_id = p.product_id
			LEFT JOIN Sizes AS s ON i.size_id = s.size_id
			LEFT JOIN Colors as col ON i.color_id = col.color_id
	GROUP BY catagory_name, brand_name, product_name, size_code, color_name;
