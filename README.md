# Color-Linez
This is an iOS implementation of classic game of Color Linez. Basic idea of the game is moving balls in table to get rid of
them. After each move, if 5 or more balls are in the same order whether vertically, horizantally or diagonally, they will be
removed from table and no more balls added. If there aren't any match after the move, then three more balls will be added to
the table. Game ends when there are no more spaces to move. Ball movements only allowed horizontally or vertically but not 
diagonally and balls can't travel through the squares that contains other balls. Problem of moving ball from one position to 
another is solved by an augmented A* search and probably the most interesting part of this project. All rights about the game
belongs to their respective owners. I've written this code on my own for practice purposes.

![IMG_2016](https://user-images.githubusercontent.com/45623751/77190142-ca2b9700-6ae9-11ea-8872-313f473c340b.PNG)

![IMG_2017](https://user-images.githubusercontent.com/45623751/77190150-cd268780-6ae9-11ea-94d2-0e4fc9e94bb1.PNG)

![IMG_2012](https://user-images.githubusercontent.com/45623751/77190160-cf88e180-6ae9-11ea-99b9-211289387b1f.PNG)

![IMG_2013](https://user-images.githubusercontent.com/45623751/77190163-d152a500-6ae9-11ea-9285-c4aaca9aeb4c.PNG)
