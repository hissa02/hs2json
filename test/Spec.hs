module Main where

import SimpleJSON
import Test.QuickCheck

-- Verifica se getString recupera o texto corretamente
prop_getString :: String -> Bool
prop_getString s =
    getString (JString s) == Just s


-- Gera valores JSON aleatorios
instance Arbitrary JValue where
    arbitrary = sized genJValue

genJValue :: Int -> Gen JValue
genJValue n
    | n <= 0 = oneof valoresSimples
    | otherwise =
        frequency
            [ (4, oneof valoresSimples)
            , (1, genArray)
            , (1, genObject)
            ]
  where
    valoresSimples =
        [ JString <$> arbitrary
        , JNumber <$> arbitrary
        , JBool <$> arbitrary
        , pure JNull
        ]

    tamanho = n `div` 2

    genArray =
        JArray <$> resize tamanho
            (listOf (genJValue tamanho))

    genObject =
        JObject <$> resize tamanho
            (listOf ((,) <$> arbitrary
                         <*> genJValue tamanho))



-- Verifica se getBool recupera o booleano
prop_getBool :: Bool -> Bool
prop_getBool b =
    getBool (JBool b) == Just b

-- Verifica se getDouble recupera o numero
prop_getDouble :: Double -> Bool
prop_getDouble n =
    getDouble (JNumber n) == Just n

-- Verifica se getArray recupera os elementos
prop_getArray :: [JValue] -> Bool
prop_getArray valores =
    getArray (JArray valores) == Just valores

-- Verifica se isNull identifica valores nulos
prop_isNull :: JValue -> Bool
prop_isNull valor =
    isNull valor == (valor == JNull)


main :: IO ()
main = do
    quickCheck prop_getString
    quickCheck prop_getBool
    quickCheck prop_getDouble
    quickCheck prop_getArray
    quickCheck prop_isNull
