/* Vote Database */
-- Creates the database that will be used for this project
CREATE DATABASE IF NOT EXISTS vote;

/* Accounts Table */
-- Creates the table that is used for storing account information
CREATE TABLE IF NOT EXISTS accounts (
    accId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uname VARCHAR(50) NOT NULL UNIQUE,    -- the user's username
    pwd VARCHAR(56) NOT NULL,    -- the user's password
    fname VARCHAR(25) NOT NULL,    -- the user's first & last name
    lname VARCHAR(25) NOT NULL,
    email VARCHAR(56) NOT NULL,    -- will be encrypted in the database
    age TINYINT NOT NULL CHECK (age > 17 AND age <= 120),
    addr VARCHAR(25) NOT NULL UNIQUE,    -- the street the user lives on
    city VARCHAR(48) NOT NULL,
    state VARCHAR(14) NOT NULL,
    zipCode CHAR(5) NOT NULL UNIQUE CHECK (LENGTH(TRIM(zipCode)) = 5),
    poliAffil VARCHAR(11) NOT NULL    -- the political affiliation of the user
) ENGINE = innoDB;    -- specifies which MySQL engine to use

/* Votes Table */
-- Creates the table that is used to store votes
CREATE TABLE IF NOT EXISTS votes (
    voteId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    accId INT UNSIGNED,
    FOREIGN KEY(accId) REFERENCES accounts(accId),
    candidate VARCHAR(50) NOT NULL,    -- who a user voted for
    polParty VARCHAR(11) NOT NULL    -- the party that the candidate is part of
) ENGINE = innoDB;

/* Donations Table */
-- Creates the table that is used to store donations and other related information 
CREATE TABLE IF NOT EXISTS donations (
    donatId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    accId INT UNSIGNED,
    FOREIGN KEY(accId) REFERENCES accounts(accId),
    amount DEC(6,2) NOT NULL CHECK (amount <= 9999.99),    -- the amount of the donation that was made
    credCardNum VARCHAR(56),    -- will be encrypted in the database
    cvv VARCHAR(56),    -- VARCHAR() used because it will be encrypted in the database
    credExpMon VARCHAR(9),    -- the credit card's expiration month
    credExpYr YEAR,    -- the credit card's expiration year
    bitcoin VARCHAR(56)    -- will be encrypted in the database    
) ENGINE = innoDB;

/* VoteDonate Table */
-- Creates the table that is used to keep track of the dates that each candidate recieved donations 
CREATE TABLE IF NOT EXISTS voteDonate (
    voteId INT UNSIGNED,
    FOREIGN KEY(voteId) REFERENCES votes(voteId),
    donatId INT UNSIGNED,
    FOREIGN KEY(donatId) REFERENCES donations(donatId),
    donatDate DATE NOT NULL  -- the date a donation was placed
) ENGINE = innoDB;

/* Salt Table */
-- Creates the table that is used to contain the salt for encrypting data
CREATE TABLE IF NOT EXISTS salt (
    salId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    accId INT UNSIGNED,
    FOREIGN KEY(accId) REFERENCES accounts(accId),
    salt VARCHAR(255),
    updated CHAR(1) DEFAULT 'N' CHECK (updated = 'Y'OR updated = 'N')   -- indicates if an account was updated
) ENGINE = innoDB;