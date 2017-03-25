module TestData where

import Data.IntMap as IMap
import Data.Map.Strict as Map
import Data.Set as Set

data Codegen = C | JS deriving (Show, Eq, Ord)
type Index = Int
data CompatCodegen = ANY | C_CG | NODE_CG | NONE

-- A TestFamily groups tests that share the same theme
data TestFamily = TestFamily {
  -- A shorter lowcase name to use in filenames
  id :: String,
  -- A proper name for the test family that will be displayed
  name :: String,
  -- A map of test metadata:
  --   - The key is the index (>=1 && <1000)
  --   - The value is the set of compatible code generators,
  --   or Nothing if the test doesn't depend on a code generator
  tests :: IntMap (Maybe (Set Codegen))
} deriving (Show)

toCodegenSet :: CompatCodegen -> Maybe (Set Codegen)
toCodegenSet compatCodegen = fmap Set.fromList mList where
  mList = case compatCodegen of
            ANY   -> Just [ C, JS ]
            C_CG  -> Just [ C ]
            NODE_CG -> Just [ JS ]
            NONE  -> Nothing

testFamilies :: [TestFamily]
testFamilies = fmap instantiate testFamiliesData where
  instantiate (id, name, testsData) = TestFamily id name tests where
    tests = IMap.fromList (fmap makeSetCodegen testsData)
    makeSetCodegen (index, codegens) = (index, toCodegenSet codegens)

testFamiliesForCodegen :: Codegen -> [TestFamily]
testFamiliesForCodegen codegen =
  fmap (\testFamily -> testFamily {tests = IMap.filter f (tests testFamily)})
       testFamilies
    where
      f mCodegens = case mCodegens of
                     Just codegens -> Set.member codegen codegens
                     Nothing       -> True

-- The data to instanciate testFamilies
-- The first column is the id
-- The second column is the proper name (the prefix of the subfolders)
-- The third column is the data for each test
testFamiliesData :: [(String, String, [(Index, CompatCodegen)])]
testFamiliesData = [
  ("base",            "Base",
    [ (  1, C_CG )]),
  ("basic",           "Basic",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      (  6, ANY  ),
      (  7, C_CG ),
      (  8, ANY  ),
      (  9, ANY  ),
      ( 10, ANY  ),
      ( 11, C_CG ),
      ( 12, ANY  ),
      ( 13, ANY  ),
      ( 14, ANY  ),
      ( 15, ANY  ),
      ( 16, ANY  ),
      ( 17, ANY  ),
      ( 18, ANY  ),
      ( 19, ANY  )]),
  ("bignum",          "Bignum",
    [ (  1, ANY  ),
      (  2, ANY  )]),
  ("bounded",         "Bounded",
    [ (  1, ANY  )]),
  ("buffer",          "Buffer",
    [ (  1, C_CG  )]),
  ("corecords",       "Corecords",
    [ (  1, ANY  ),
      (  2, ANY  )]),
  ("delab",           "De-elaboration",
    [ (  1, ANY  )]),
  ("directives",      "Directives",
    [ (  1, ANY  ),
      (  2, ANY  )]),
  ("disambig",        "Disambiguation",
    [ (  2, ANY  )]),
  ("docs",            "Documentation",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      (  6, ANY  )]),
  ("dsl",             "DSL",
    [ (  1, ANY  ),
      (  2, C_CG ),
      (  3, ANY  ),
      (  4, ANY  )]),
  ("effects",         "Effects",
    [ (  1, C_CG ),
      (  2, C_CG ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  )]),
  ("error",           "Errors",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      (  6, ANY  ),
      (  7, ANY  ),
      (  8, ANY  ),
      (  9, ANY  )]),
  ("ffi",             "FFI",
    [ (  1, ANY  )
    , (  2, ANY  )
    , (  3, ANY  )
    , (  4, ANY  )
    , (  5, ANY  )
    , (  6, C_CG )
    , (  7, C_CG )
    , (  8, C_CG )
    , (  9, C_CG )
    ]),
  ("folding",         "Folding",
    [ (  1, ANY  )]),
  ("idrisdoc",        "Idris documentation",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      (  6, ANY  ),
      (  7, ANY  ),
      (  8, ANY  ),
      (  9, ANY  )]),
  ("interactive",     "Interactive editing",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      (  6, ANY  ),
      (  7, ANY  ),
      (  8, ANY  ),
      (  9, ANY  ),
      ( 10, ANY  ),
      ( 11, ANY  ),
      ( 12, ANY  ),
      ( 13, ANY  )]),
  ("interfaces",      "Interfaces",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
--       (  5, ANY  ),
      (  6, ANY  ),
      (  7, ANY  )]),
  ("io",              "IO monad",
    [ (  1, C_CG ),
      (  2, ANY  ),
      (  3, C_CG )]),
  ("layout",          "Layout",
    [ (  1, ANY  )]),
  ("literate",        "Literate programming",
    [ (  1, ANY  )]),
  ("meta",            "Meta-programming",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  )]),
  ("pkg",             "Packages",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      (  6, ANY  ),
      (  7, ANY  ),
      (  8, ANY  )]),
  ("prelude",         "Prelude",
    [ (  1, ANY  )]),
  ("primitives",      "Primitive types",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  5, C_CG ),
      (  6, C_CG )]),
  ("proof",           "Theorem proving",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      (  6, ANY  ),
      (  7, ANY  ),
      (  8, ANY  ),
      (  9, ANY  ),
      ( 10, ANY  ),
      ( 11, ANY  )]),
  ("proofsearch",     "Proof search",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  )]),
  ("pruviloj",        "Pruviloj",
    [ (  1, ANY  )]),
  ("quasiquote",      "Quasiquotations",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      (  6, ANY  )]),
  ("records",         "Records",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  )]),
  ("reg",             "Regressions",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      ( 13, ANY  ),
      ( 16, ANY  ),
      ( 17, ANY  ),
      ( 20, ANY  ),
      ( 24, ANY  ),
      ( 25, ANY  ),
      ( 27, ANY  ),
      ( 29, C_CG ),
      ( 31, ANY  ),
      ( 32, ANY  ),
      ( 39, ANY  ),
      ( 40, ANY  ),
      ( 41, ANY  ),
      ( 42, ANY  ),
      ( 45, ANY  ),
      ( 48, ANY  ),
      ( 52, C_CG ),
      ( 67, ANY  ),
      ( 75, ANY  ),
      ( 76, ANY  ),
      ( 77, ANY  )]),
  ("regression",      "Regression",
    [ (  1 , ANY  ),
      (  2 , ANY  )]),
  ("sourceLocation",  "Source location",
    [ (  1 , ANY  )]),
  ("sugar",           "Syntactic sugar",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, C_CG ),
      (  5, ANY  )]),
  ("syntax",          "Syntax extensions",
    [ (  1, ANY  ),
      (  2, ANY  )]),
  ("tactics",         "Tactics",
    [ (  1, ANY  )]),
  ("totality",        "Totality checking",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      (  6, ANY  ),
      (  7, ANY  ),
      (  8, ANY  ),
      (  9, ANY  ),
      ( 10, ANY  ),
      ( 11, ANY  ),
      ( 12, ANY  ),
      ( 13, ANY  ),
      ( 14, ANY  ),
      ( 15, ANY  ),
      ( 16, ANY  ),
      ( 17, ANY  ),
      ( 18, ANY  ),
      ( 19, ANY  ),
      ( 20, ANY  ),
      ( 21, ANY  ),
      ( 22, ANY  )]),
  ("tutorial",        "Tutorial examples",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, ANY  ),
      (  4, ANY  ),
      (  5, ANY  ),
      (  6, ANY  ),
      (  7, C_CG )]),
  ("unique",          "Uniqueness types",
    [ (  1, ANY  ),
      (  4, ANY  )]),
  ("universes",       "Universes",
    [ (  1, ANY  ),
      (  2, ANY  )]),
  ("views",           "Views",
    [ (  1, ANY  ),
      (  2, ANY  ),
      (  3, C_CG )])]
