
import Data.Char

data Token = TLeftBracket
           | TRightBracket
           | TLeftSquareBracket
           | TRightSquareBracket
           | TLeftCurlyBracket
           | TRightCurlyBracket
           | TComma
           | TAssign
           | TEqual
           | TNotEqual
           | TGreaterThan
           | TSmallerThan
           | TGreaterEqualThan
           | TSmallerEqualThan
           | TName
           deriving (Show)

-- Tokens:
tokens = [ (TLeftBracket        , (==) "(" )
         , (TRightBracket       , (==) ")" )
         , (TLeftSquareBracket  , (==) "[" )
         , (TRightSquareBracket , (==) "]" )
         , (TLeftCurlyBracket   , (==) "{" )
         , (TRightCurlyBracket  , (==) "}" )
         , (TComma              , (==) "," )
         , (TAssign             , (==) "=" )
         , (TEqual              , (==) "==")
         , (TNotEqual           , (==) "!=")
         , (TGreaterThan        , (==) ">" )
         , (TSmallerThan        , (==) "<" )
         , (TGreaterEqualThan   , (==) ">=")
         , (TSmallerEqualThan   , (==) "<=")
         , (TName               , isName   )]

file2file ff tf = do
    fstr <- readFile ff
    writeFile tf $ unlines (splitString splitChars fstr)

lexFile :: String -> IO [String]
lexFile fp = do
    f <- readFile fp
    return $ splitString splitChars f

splitString :: [Char] -> String -> [String]
splitString ds s = rejoinMulti' (removeBlanks' (joinStr' ((splitString' ds (replaceNewLines' s "") "" [])) [])) []
           where splitString' _ [] buff ts = ts ++ [buff]
                 splitString' ds' (c:cs) buff bits
                    | elem c ds' = splitString' ds' cs "" (bits ++ [buff] ++ [[c]])
                    | otherwise  = splitString' ds' cs (buff ++ [c]) bits
                 removeBlanks' ll = ((filter ((/=) "")) . (filter ((/=) " "))) ll
                 rejoinMulti' [] nl = reverse nl
                 rejoinMulti' (l:[]) nl = reverse (l:nl) 
                 rejoinMulti' (t1:t2:ts) nl
                    | t1 ++ t2 == "==" = rejoinMulti' ts ((t1++t2):nl)
                    | t1 ++ t2 == "!=" = rejoinMulti' ts ((t1++t2):nl)
                    | t1 ++ t2 == ">=" = rejoinMulti' ts ((t1++t2):nl)
                    | t1 ++ t2 == "<=" = rejoinMulti' ts ((t1++t2):nl)
                    | t1 ++ t2 == "++" = rejoinMulti' ts ((t1++t2):nl)
                    | t1 ++ t2 == "--" = rejoinMulti' ts ((t1++t2):nl)
                    | t1 ++ t2 == "->" = rejoinMulti' ts ((t1++t2):nl)
                    | t1 ++ t2 == "<-" = rejoinMulti' ts ((t1++t2):nl)                    
                    | otherwise = rejoinMulti' (t2:ts) (t1:nl)
                 joinStr' [] n = reverse n
                 joinStr' (t:[]) n = reverse n
                 joinStr' l@(t:ts) n
                    | isQuote t = joinStr' (snd (joinStr'' l)) ((fst (joinStr'' l)):n)
                    | otherwise = joinStr' ts (t:n)
                 joinStr'' l = (('\"':(concat (takeWhile notQuote (tail l)))) ++ ['\"'],(tail (dropWhile notQuote (tail l))))
                 replaceNewLines' [] n = reverse n
                 replaceNewLines' l n
                    | head l == '\n' = replaceNewLines' (tail l) (' ':n)
                    | otherwise = replaceNewLines' (tail l) ((head l):n)

getStrUntilQ' ls = [concat $ (takeWhile ((/=) "\"")) ls]
getStrFromQ' ls = reverse (tail (reverse (tail ((dropWhile ((/=) "\"")) ls))))
getStr' ls = (getStrUntilQ' . getStrFromQ') ls

x = ["first_word","\"","print","\"","Hello",",","World","!","\"","x","=","1001",";","\"","Hello",",","World","!","\"","x"]
x2 = ["\"","Hello",",","World","!","\"", "a", "=", "10", ";"]
x3 = ["\"","Hello",",","World","!","\"", "a", "=", "10", ";"]

joinStr2 l = (concat (takeWhile notQuote (tail l))):(tail (dropWhile notQuote (tail l)))
-- joinStr l = (('\"':(concat (takeWhile notQuote (tail l)))) ++ ['\"'],(tail (dropWhile notQuote (tail l))))

-- joinParts ls
tailInit :: [a] -> [a]
tailInit = tail . init

isQuote :: String -> Bool
isQuote = (==) "\""
notQuote :: String -> Bool
notQuote = (not . isQuote)

rejoinMulti [] nl = reverse nl
rejoinMulti (l:[]) nl = reverse (l:nl) 
rejoinMulti (t1:t2:ts) nl
    | t1 ++ t2 == "==" = rejoinMulti ts ((t1++t2):nl)
    | t1 ++ t2 == "!=" = rejoinMulti ts ((t1++t2):nl)
    | t1 ++ t2 == ">=" = rejoinMulti ts ((t1++t2):nl)
    | t1 ++ t2 == "<=" = rejoinMulti ts ((t1++t2):nl)
    | otherwise = rejoinMulti (t2:ts) (t1:nl)
  

-- getStr ls = (takeWhile ((/=) "\"") ls, tail (dropWhile ((/=) "\"") (takeWhile ((/=) "\"") ls)))

-- getStrUntilQ ls = (takeWhile ((/=) "\"")) ls
-- getStrFromQ ls = tail ((dropWhile ((/=) "\"")) ls)

pr str = mapM_ print str

splitChars = "()[]{},;=<>+-*/^&|!\" "
charsSmallCapsAlphabet :: [Char]
charsSmallCapsAlphabet = ['a'..'z']
charsCapsAlphabet   :: [Char]
charsCapsAlphabet   = map toUpper charsSmallCapsAlphabet
charsNaturalNumbers    :: [Char]
charsNaturalNumbers    = map (chr . (48 + )) [0..9]
charsSpecialChars      :: [Char]
charsSpecialChars      = ['_']
nameChars :: [Char]
nameChars = charsSmallCapsAlphabet ++ charsCapsAlphabet ++ charsNaturalNumbers ++ charsSpecialChars

isName :: String -> Bool
isName = all ((flip elem) nameChars)

consumeName :: String -> String
consumeName = takeWhile ((flip elem) nameChars)

consumeChars :: [Char] -> String -> String
consumeChars cs n@(s:ss)
        | s `elem` cs = consumeChars cs ss
        | otherwise = n

consume :: String -> String
consume = consumeChars [' ']

