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


-- Verifica se os valores gerados sao iguais a si mesmos
prop_identidade :: JValue -> Bool
prop_identidade valor = valor == valor



main :: IO ()
main = do
    quickCheck prop_getString
    quickCheck prop_identidade
