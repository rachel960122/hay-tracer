module Util where
import DataTypes

minus :: Vec3 -> Vec3 -> Vec3
minus (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = Vec3 (x1 - x2) (y1 - y2) (z1 - z2)

plus :: Vec3 -> Vec3 -> Vec3
plus (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = Vec3 (x1 + x2) (y1 + y2) (z1 + z2)

vlength :: Vec3 -> Double
vlength vec = sqrt (dot vec vec)

multScaler :: Vec3 -> Double -> Vec3
multScaler (Vec3 x y z) k = Vec3 (k * x) (k * y) (k * z)

normalize :: Vec3 -> Vec3
normalize (Vec3 x1 y1 z1) =
  let invlen = 1.0 / (sqrt ((x1 * x1) + (y1 * y1) + (z1 * z1))) in
    Vec3 (x1 * invlen) (y1 * invlen) (z1 * invlen)

radians :: Double -> Double
radians x = (x * 3.1415926535897) / 180

dot :: Vec3 -> Vec3 -> Double
dot (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = (x1 * x2) + (y1 * y2) + (z1 * z2)

cross :: Vec3 -> Vec3 -> Vec3
cross (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) =
  Vec3
  ((y1 * z2) - (z1 * y2))
  ((z1 * x2) - (x1 * z2))
  ((x1 * y2) - (y1 * x2))

clampVec :: Vec3 -> Vec3 -> Vec3 -> Vec3
clampVec (Vec3 minx miny minz) (Vec3 x y z) (Vec3 maxx maxy maxz)
  = Vec3 (clamp minx x maxx) (clamp miny y maxy) (clamp minz z maxz)

clamp :: Double -> Double -> Double -> Double
clamp min x max
 | x < min = min
 | x > max = max
 | otherwise = x

{-
clamp :: Vec3 -> Vec3
clamp (Vec3 r g b) = Vec3 (clampdouble r) (clampdouble g) (clampdouble b)
                where clampdouble f = (max 0.0 (min 1.0 f))
-}

vdistance :: Vec3 -> Vec3 -> Double
vdistance v1 v2 = let d = minus v2 v1 in vlength d
