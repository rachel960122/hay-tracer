module DataTypes where

import Prelude

type Point = Vec3
type Color = Vec3

data Vec3 = Vec3 Double Double Double
  deriving Show
data Vec4 = Vec4 Double Double Double Double
  deriving Show

-- Sphere Vec3 (center) Double (radius) | Plane Vec4 (coefficients)
data Object = Sphere Vec3 Double | Plane Vec4
  deriving Show
-- Camera Point (camera pos) Point (at point) Vec3 (up Vec3tor) Double (fovy)
data Camera = Camera Point Point Vec3 Double
  deriving Show
-- Image Int (width) Int (height)
data Image = Image Int Int
  deriving Show
-- Light Point (source) Color (intensity) Vec3c3 (attenuation)
data Light = Light Point Color Vec3
  deriving Show
-- Ray Point (origin) Vec3 (direction)
data Ray = Ray Point Vec3
  deriving Show
-- Solid Color (RGB components) | CheckerBoard Color (color1) Color (color2) Double (square size)
data Pigment = Solid Color | CheckerBoard Color Color Double
  deriving Show
-- PhongCoef Double (ambient coef) Double (diffuse coef) Double (specular coef) Double (shininess)
data PhongCoef = PhongCoef Double Double Double Double
  deriving Show
-- Surface PhongCoef Double (reflectivity coef) Double (transmission coef) Double (index of refraction)
data Surface = Surface PhongCoef Double Double Double
  deriving Show
