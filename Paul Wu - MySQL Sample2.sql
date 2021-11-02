CREATE TABLE users (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
 
CREATE TABLE photos (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id)
);
 
CREATE TABLE comments (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    comment_text VARCHAR(255) NOT NULL,
    photo_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);
 
CREATE TABLE likes (
    user_id INTEGER NOT NULL,
    photo_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    PRIMARY KEY(user_id, photo_id)
);
 
CREATE TABLE follows (
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(follower_id) REFERENCES users(id),
    FOREIGN KEY(followee_id) REFERENCES users(id),
    PRIMARY KEY(follower_id, followee_id)
);
 
CREATE TABLE tags (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  tag_name VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT NOW()
);
 
CREATE TABLE photo_tags (
    photo_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(tag_id) REFERENCES tags(id),
    PRIMARY KEY(photo_id, tag_id)
);

# find the oldest users
SELECT * FROM users
ORDER BY created_at ASC LIMIT 5;

#the day of the week most users craeted on
SELECT COUNT(*) AS '# of users cerated', DAYNAME(created_at) AS Day FROM users 
    GROUP BY Day
    ORDER BY '# of users created' DESC LIMIT 1;
    
    
#the user who never posted anything
SELECT username, image_url FROM users 
    LEFT JOIN photos 
        ON users.id = photos.user_id 
WHERE image_url IS NULL;


#user with most likes
SELECT username, COUNT(*) AS most_likes, photos.image_url AS 'winning photo' FROM users
    LEFT JOIN photos
        ON users.id = photos.user_id
    LEFT JOIN likes 
        ON photos.id = likes.photo_id 
    GROUP BY photos.id 
    ORDER BY most_likes DESC LIMIT 1;
    
    
#average times of user post
SELECT COUNT(image_url) / COUNT(DISTINCT username) 
FROM users 
    LEFT JOIN photos 
        ON users.id = photos.user_id;
        

#top 5 most commonly used hashtag
SELECT tag_name, COUNT(*) AS TOTAL FROM tags
    LEFT JOIN photo_tags 
        ON tags.id = photo_tags.tag_id 
GROUP BY tag_name 
ORDER BY TOTAL DESC LIMIT 5;


#find users who likes every photo
SELECT username, COUNT(*) AS num_likes 
FROM users
    LEFT JOIN likes
    ON users.id = likes.user_id
    GROUP BY username
HAVING num_likes = (SELECT COUNT(*) FROM photos);
