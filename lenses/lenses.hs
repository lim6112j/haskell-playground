{-# LANGUAGE TemplateHaskell #-}
import Control.Lens
data Point = Point
  { _positionX :: Double
    , _positionY :: Double
  } deriving (Show)
makeLenses ''Point
data Segment = Segment
  { _segmentStart :: Point
    , _segmentEnd :: Point
  } deriving (Show)
makeLenses ''Segment
makePoint :: (Double, Double) -> Point
makePoint (x, y) = Point x y

makeSegment :: (Double, Double) -> (Double, Double) -> Segment
makeSegment start end = Segment (makePoint start) (makePoint end)
-- traversal
pointCoordinates :: Applicative f => (Double -> f Double) -> Point -> f Point
pointCoordinates g (Point x y) = Point <$> g x <*> g y

main :: IO ()
main = do
  let testseg = makeSegment (0, 1) (2, 4)
  print $ view segmentEnd testseg
  print $ testseg^.segmentEnd
  print $ (segmentEnd . positionY) .~ 0 $ testseg
  print $ testseg & (segmentEnd . positionY) .~ 0
  print $ over (segmentEnd . positionY) (*2) testseg
  print $ (segmentEnd . positionY) %~ (*2) $ testseg
  let deleteIfNegative x = if x < 0 then Nothing else Just x
  print $ pointCoordinates deleteIfNegative (makePoint (1, 2))
  print $ pointCoordinates deleteIfNegative (makePoint (1, -2))

