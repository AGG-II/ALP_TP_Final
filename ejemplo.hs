import Parse
main = do
    handle <- readFile "ejemplo.ca"     
    print (parseador handle)