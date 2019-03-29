import StackTest
import System.Directory (withCurrentDirectory)

main :: IO ()
main = do
    -- cleanup previous failing test...
    removeDirIgnore "tmpPackage"

    stack ["new", "--resolver=lts-13.11", "tmpPackage"]

    -- use a commit which is known to succeed with hadrian binary-dist
    let commitId = "33b0a291898b6a35d822fde59864c5c94a53d039"
        flavour  = "quick"

    withCurrentDirectory "tmpPackage" $ do
       appendFile "stack.yaml" $ unlines
         [ "compiler-repository: https://gitlab.haskell.org/ghc/ghc.git"
         , "compiler: ghc-git-" ++ commitId ++ "-" ++ flavour
         ]

       -- Setup the package
       stack ["setup"]

       -- build it with the built GHC
       stack ["build"]

    -- cleanup
    removeDirIgnore "tmpPackage"
