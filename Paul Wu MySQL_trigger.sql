# Such a trigger shows warning when inserting values into the follows table with 2 same user ID 
DELIMITER $$
CREATE TRIGGER prevent_following_myself
    BEFORE INSERT ON follows FOR EACH ROW
    BEGIN
         IF NEW.follower_id = NEW.followee_id
         THEN
             SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot Follow Yourself.'
         END IF;
END;
$$

DELIMITER;

# This trigger logs data into table when users unfollows each other
CREATE TABLE unfollows (
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(follower_id) REFERENCES users(id),
    FOREIGN KEY(followee_id) REFERENCES users(id),
    PRIMARY KEY(follower_id, followee_id)
);

DELIMITER $$
CREATE TRIGGER logs_unfollows
    AFTER DELETE ON follows FOR EACH ROW
BEGIN
    INSERT INTO unfollows
    SET follower_id = OLD.follower_id, followee_id = OLD.followee_id;
    
END $$

DELIMITER ;