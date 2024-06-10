CREATE DATABASE BankDatabase;
USE BankDatabase;

CREATE TABLE PhysicalPersons (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    middle_name VARCHAR(50),
    passport_number VARCHAR(20),
    inn VARCHAR(12),
    snils VARCHAR(11),
    driving_license VARCHAR(20),
    additional_documents TEXT,
    note TEXT
);

ALTER TABLE PhysicalPersons MODIFY id INT AUTO_INCREMENT;

CREATE TABLE Loans (
    id INT PRIMARY KEY,
    person_id INT,
    amount DECIMAL(10, 2),
    percentage DECIMAL(5, 2),
    rate VARCHAR(20),
    term INT,
    conditions TEXT,
    note TEXT,
    FOREIGN KEY (person_id) REFERENCES PhysicalPersons(id)
);

CREATE TABLE OrganizationLoans (
    id INT PRIMARY KEY,
    organization_id INT,
    person_id INT,
    amount DECIMAL(10, 2),
    term INT,
    percentage DECIMAL(5, 2),
    conditions TEXT,
    note TEXT,
    FOREIGN KEY (organization_id) REFERENCES Borrowers(id),
    FOREIGN KEY (person_id) REFERENCES PhysicalPersons(id)
);

CREATE TABLE Borrowers (
    id INT PRIMARY KEY,
    inn VARCHAR(12),
    bin VARCHAR(20),
    full_name VARCHAR(100),
    address VARCHAR(100),
    amount DECIMAL(10, 2),
    conditions TEXT,
    legal_notes TEXT,
    contracts TEXT
);

INSERT INTO PhysicalPersons (id, first_name, last_name, middle_name, passport_number, inn, snils, driving_license, additional_documents, note) 
VALUES 
(1, 'Иван', 'Иванов', 'Иванович', '123456', '1234567890', '12345678901', 'DL12345', 'Док1, Док2', 'Примечание для персоны 1'),
(2, 'Анна', 'Петрова', 'Сергеевна', '456789', '0987654321', '54321678903', 'DL54321', 'Док3, Док4', 'Примечание для персоны 2'),
(3, 'Михаил', 'Сидоров', 'Павлович', '789012', '9876543210', '32109876543', 'DL98765', 'Док5, Док6', 'Примечание для персоны 3'),
(4, 'Екатерина', 'Козлова', 'Дмитриевна', '123456', '1234546789', '67891234567', 'DL23456', 'Док7, Док8', 'Примечание для персоны 4'),
(5, 'Александр', 'Смирнов', 'Александрович', '789012', '7654321987', '98761234567', 'DL67890', 'Док9, Док10', 'Примечание для персоны 5');