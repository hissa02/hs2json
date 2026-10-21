module Prettify
    ( Doc
    , empty
    , char
    , text
    , line
    , softline
    , (<>)
    , (<+>)
    , hsep
    , vsep
    , indent
    , render
    ) where

import Prelude hiding ((<>))

-- | Tipo abstrato que representa um documento formatado.
data Doc = Empty
         | Char Char
         | Text String
         | Line
         | Cat Doc Doc
         | Union Doc Doc
         | Nest Int Doc
         deriving (Show)

-- | Documento vazio.
empty :: Doc
empty = Empty

-- | Um único caractere.
char :: Char -> Doc
char c = Char c

-- | Um texto (string) literal.
text :: String -> Doc
text "" = Empty
text s  = Text s

-- | Uma quebra de linha obrigatória.
line :: Doc
line = Line

-- | Uma quebra de linha que pode virar espaço (softline).
softline :: Doc
softline = Union (char ' ') Line

-- | Concatenação de documentos.
(<>) :: Doc -> Doc -> Doc
Empty <> y = y
x <> Empty = x
x <> y = Cat x y

-- | Concatena com um espaço no meio.
(<+>) :: Doc -> Doc -> Doc
x <+> y = x <> char ' ' <> y

-- | Junta uma lista de documentos com espaços.
hsep :: [Doc] -> Doc
hsep = foldr (<+>) empty

-- | Junta uma lista de documentos com quebras de linha.
vsep :: [Doc] -> Doc
vsep = foldr (\x y -> x <> line <> y) empty

-- | Indenta um documento em @n@ espaços.
indent :: Int -> Doc -> Doc
indent = Nest

-- | Transforma um Doc em String, respeitando as regras de formatação.
render :: Doc -> String
render = best 0 0

-- Função interna: escolhe a melhor representação (compacta ou quebrada).
best :: Int -> Int -> Doc -> String
best _ _ Empty = ""
best w k (Char c) = [c]
best _ _ (Text s) = s
best w k (Line) = '\n' : replicate k ' '
best w k (Cat x y) = best w k x ++ best w k y
best w k (Union x y) = better w k (best w k x) (best w k y)
best w k (Nest i x) = best w (k + i) x

-- Escolhe a versão que cabe na largura disponível.
better :: Int -> Int -> String -> String -> String
better w k x y
    | width x <= w = x
    | otherwise    = y
  where
    width s = length (takeWhile (/= '\n') s)