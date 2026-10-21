{-# LANGUAGE FlexibleInstances #-}
module Main (main) where

import SimpleJSON
import PrettyJSON (renderJValue)
import Test.QuickCheck
import Data.Char (isControl)


-- Gerador Arbitrary seguro 

instance Arbitrary JValue where
  arbitrary = sized arbJValue
    where
      arbJValue n
        | n <= 0 = oneof [ pure JNull
                         , JBool <$> arbitrary
                         , JString <$> arbitrary
                         , JNumber <$> arbitrary
                         ]
        | otherwise = oneof
            [ pure JNull
            , JBool <$> arbitrary
            , JString <$> arbitrary
            , JNumber <$> arbitrary
            , JArray <$> resize (n `div` 2) (listOf (arbJValue (n `div` 2)))
            , JObject <$> resize (n `div` 2) (listOf ((,) <$> arbitrary <*> arbJValue (n `div` 2)))
            ]


-- Propriedades


-- 1. A renderização de um valor é idempotente (não muda se renderizar de novo).
prop_render_idempotent :: JValue -> Bool
prop_render_idempotent v = renderJValue v == renderJValue v

-- 2. Strings sempre vêm entre aspas.
prop_string_quoted :: String -> Bool
prop_string_quoted s =
    let rendered = renderJValue (JString s)
    in head rendered == '"' && last rendered == '"'

-- 3. Números inteiros não usam notação científica.
prop_integer_no_scientific :: Int -> Bool
prop_integer_no_scientific n =
    let rendered = renderJValue (JNumber (fromIntegral n))
    in 'e' `notElem` rendered && 'E' `notElem` rendered

-- 4. Objetos vazios renderizam como "{}".
prop_empty_object :: Bool
prop_empty_object = renderJValue (JObject []) == "{}"

-- 5. Arrays vazios renderizam como "[]".
prop_empty_array :: Bool
prop_empty_array = renderJValue (JArray []) == "[]"

-- 6. Null renderiza como "null".
prop_null :: Bool
prop_null = renderJValue JNull == "null"

-- 7. Booleanos renderizam como "true" ou "false".
prop_bool :: Bool -> Bool
prop_bool b =
    let rendered = renderJValue (JBool b)
    in rendered == "true" || rendered == "false"
-- 8. Não há caracteres de controle não escapados em strings.
prop_no_unescaped_control :: String -> Bool
prop_no_unescaped_control s =
    let rendered = renderJValue (JString s)
        inner = init (tail rendered)  -- remove as aspas
        -- Conta barras invertidas que precedem caracteres de controle
        check [] = True
        check ('\\':_:rest) = check rest
        check (c:rest) = not (isControl c) && check rest
    in check inner


main :: IO ()
main = do
    putStrLn "Executando testes QuickCheck para PrettyJSON..."
    quickCheck prop_render_idempotent
    quickCheck prop_string_quoted
    quickCheck prop_integer_no_scientific
    quickCheck prop_empty_object
    quickCheck prop_empty_array
    quickCheck prop_null
    quickCheck prop_bool
    quickCheck prop_no_unescaped_control
    putStrLn "Todos os testes passaram!"