module CAGraphics where
import CelAutoGen
import Graphics.Gloss hiding  (makeColor)
import Graphics.Gloss.Interface.Pure.Simulate

correr ca name = let (x,y) = getDimGrid ca
                     thisGrid = drawGrid (fromIntegral x) (fromIntegral y)
                     mySquare = square (fromIntegral x) (fromIntegral y)
                     myDrawCell = drawCell mySquare (fromIntegral x) (fromIntegral y)
                 in  simulate 
                       (window name)
                       white       
                       1
                       ca
                       (render thisGrid myDrawCell)
                       update      

-- window width and height in pixels
width = 600
height = 600

-- Defines a grid space with padding
padding = 100
w = (fromIntegral width) - padding
h = (fromIntegral height) - padding

-- Filled in cells look like this
square x y = rectangleSolid (w/x) (h/y)

-- defines the window of the canvas
window xs = InWindow xs (width, height) (0,0)

render :: [Picture] -> ((Int,Int) -> Picture) -> CelAuto -> Picture
render thisGrid myDrawCell ca = pictures $ thisGrid ++ coloredCells
  where
    cells = getCells ca
    coloredCells = toListCells (mapCells toColor cells)
    colors = states ca
    toColor (cd, name) = color (getColor colors name) $ myDrawCell cd

drawCell sq x y (x0,y0) =  translate ((fromIntegral x0)*w/x -w/2 +  w/x/2) (-(fromIntegral y0)*h/y +h/2 -h/y/2) sq



-- defines the grid and the size of each cell
drawGrid x y = verticalLines ++ horizontalLines ++ [rectangleWire w h]
    where verticalLines = foldr (\a -> \b -> vLine a:b) [] [0..x] 
          vLine a = color  (greyN 0.5)  (line [ (w/x*a-w/2, -h/2), (w/x*a-w/2, h-h/2) ])
          horizontalLines = foldr (\a -> \b -> hLine a:b) [] [0..y] 
          hLine a = color  (greyN 0.5)  (line [ (-w/2, h/y*a-h/2), (w-w/2, h/y*a-h/2) ])

update :: ViewPort -> Float -> CelAuto -> CelAuto
update _ _ ca = next ca