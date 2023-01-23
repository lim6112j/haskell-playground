data Point = Point
  { positionX :: Double
    , positionY :: Double
  } deriving (Show)

data Segment = Segment
  { segmentStart :: Point
    , segmentEnd :: Point
  } deriving (Show)

makePoint :: (Double, Double) -> Point
makePoint (x, y) = Point x y

makeSegment :: (Double, Double) -> (Double, Double) -> Segment
makeSegment start end = Segment (makePoint start) (makePoint end)

