-- Создать базу данных
CREATE DATABASE Observatory;
USE Observatory;

CREATE TABLE Sector (
    id INT AUTO_INCREMENT PRIMARY KEY,
    coordinates VARCHAR(255),
    light_intensity FLOAT,
    foreign_objects INT,
    num_stellar_objects INT,
    num_undefined_objects INT,
    num_defined_objects INT,
    notes TEXT
);

CREATE TABLE Objects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(255),
    determination_accuracy FLOAT,
    quantity INT,
    time TIME,
    date DATE,
    notes TEXT
);

CREATE TABLE NaturalObjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(255),
    galaxy VARCHAR(255),
    accuracy FLOAT,
    luminous_flux FLOAT,
    associated_objects VARCHAR(255),
    notes TEXT
);

CREATE TABLE Positions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    earth_position VARCHAR(255),
    sun_position VARCHAR(255),
    moon_position VARCHAR(255)
);

CREATE TABLE Relations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sector_id INT,
    object_id INT,
    natural_object_id INT,
    position_id INT,
    FOREIGN KEY (sector_id) REFERENCES Sector(id),
    FOREIGN KEY (object_id) REFERENCES Objects(id),
    FOREIGN KEY (natural_object_id) REFERENCES NaturalObjects(id),
    FOREIGN KEY (position_id) REFERENCES Positions(id)
);

DELIMITER //

CREATE TRIGGER trg_after_update_objects
AFTER UPDATE ON Objects
FOR EACH ROW
BEGIN
    DECLARE col_exists INT;
    
    SET col_exists = (
        SELECT COUNT(*) 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME='Objects' 
        AND COLUMN_NAME='date_update'
    );
    
    IF col_exists = 0 THEN
        -- Эта строка вызывает ошибку. Неявный коммит внутри триггера!
        ALTER TABLE Objects ADD COLUMN date_update DATETIME;
    END IF;
    
    UPDATE Objects SET date_update = NOW() WHERE id = NEW.id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE join_tables(
    IN table1 VARCHAR(255),
    IN table2 VARCHAR(255)
)
BEGIN
    SET @query = CONCAT(
        'SELECT * FROM ', table1, ' t1 JOIN ', table2, ' t2 ON t1.id = t2.id;'
    );
    
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE update_objects(
    IN p_id INT,
    IN p_type VARCHAR(255),
    IN p_determination_accuracy FLOAT,
    IN p_quantity INT,
    IN p_time TIME,
    IN p_date DATE,
    IN p_notes TEXT
)
BEGIN
    UPDATE Objects
    SET 
        type = p_type,
        determination_accuracy = p_determination_accuracy,
        quantity = p_quantity,
        time = p_time,
        date = p_date,
        notes = p_notes
    WHERE id = p_id;
    
    CALL join_tables('Objects', 'Sector');
END //

DELIMITER ;

INSERT INTO Objects (type, determination_accuracy, quantity, time, date, notes)
VALUES 
('Star', 98.5, 1, '12:34:56', '2023-10-01', 'Brightest star observed in the night sky.'),
('Planet', 87.2, 2, '14:15:22', '2023-10-05', 'Two new planets in the habitable zone.'),
('Comet', 75.4, 1, '22:20:10', '2023-10-10', 'Comet passing close to Earth.'),
('Asteroid', 92.7, 5, '03:45:30', '2023-10-15', 'Cluster of asteroids detected in asteroid belt.'),
('Nebula', 80.3, 1, '18:50:15', '2023-10-20', 'A new nebula formation observed in the Milky Way.'),
('Galaxy', 96.1, 1, '10:30:00', '2023-10-25', 'Newly discovered dwarf galaxy.'),
('Star', 99.0, 3, '16:25:47', '2023-10-30', 'Triple star system found in nearby galaxy.'),
('Exoplanet', 85.5, 7, '06:14:33', '2023-11-01', 'Newly identified exoplanets in distant system.'),
('Black Hole', 97.9, 1, '08:22:11', '2023-11-05', 'Massive black hole observation.'),
('Supernova', 89.3, 1, '23:05:50', '2023-11-10', 'Recent supernova event in a distant galaxy.');