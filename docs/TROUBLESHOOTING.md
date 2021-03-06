# Troubleshooting

**Cabal-helper-wrapper can't install cabal**

Drop in to the nix-shell for the project and run `cabal new-update`.

**I'm getting an error in an existing file saying that I need to enable a language pragma**

Drop in to the nix-shell for the project and run `cabal new-udpate`.

## Haskell-ide-engine troubleshooting

Haskell-ide-engine also maintain [their own troubleshooting section](https://github.com/haskell/haskell-ide-engine#troubleshooting) that is worth looking in to.

**Haskell-ide-engine seems to have stopped working**

Yeah, it currently crashes a bit. It doesn't seem to handle file creation or deletion very well, nor updating the PROJECT_NAME.{nix|cabal} files. Hopefully this improves over time, this is still a very young plugin.

This can sometimes also *seem* to occur if there is a specific problem in another file, such as a non-existant import, thankfully the fix there is to just fix up the issue at the source, but it might not be obvious why the file you're currently looking at isn't getting type-checked.

**Haskell-ide-engine says it can't satisfy a package**

Sometimes when updating HIE or GHC you may see an error message like the following appear when you start HIE and when you save a file.

> Got error while processing diagnostics: <command line>: cannot satisfy -package-id aeson-1.3.1.1-Lq3qt0bucT8Ce9ru8xJuCI (use -v for more information)

To resolve this jump in to the nix-shell and run `cabal install`.

**'GHC: Can't find a pacakge database' during `nix-build`**

This can happen if you jump back and forth between `cabal new-*` and `nix-build`. Just delete the `.ghc.environment.*` file and try nix-build again.

```
Loaded package environment from /private/tmp/nix-build-my-awesome-ws-0.0.1.drv-0/my-awesome-ws/.ghc.environment.x86_64-darwin-8.4.3
ghc: can't find a package database at /private/tmp/nix-build-my-awesome-ws-0.0.1.drv-0/my-awesome-ws/dist-newstyle/packagedb/ghc-8.4.3
builder for '/nix/store/v75i0a3p899imjzh9a9x4lig2wk4fi58-my-awesome-ws-0.0.1.drv' failed with exit code 1
```

**I get a `createReadProcess` error whenever I save**

If you look in the the Haskell-Ide-Engine logs and see the following error message;

```
cabal-helper-wrapper: $projectRoot/dist-newstyle/build/$platform/$ghc/$projectNameAndVersion/setup-config: openFile: does not exist (No such file or directory)
```

Then inside a `nix-shell`, run `cabal new-build`. Once this succeeds that file will be created. You must be able to get at least one successful compile.


**I can run `cabal new-build` just fine, but `nix-build` fails**

If when you run `nix-build` it fails, and you see output similar to the following;

```
Loaded package environment from /build/$project/.ghc.environment.x86_64-linux-8.6.4
ghc: can't find a package database at /home/$user/.cabal/store/ghc-8.6.4/package.db
```

Then there's an environment file floating around in your build directory. This is created when you run `cabal new-build`, so jumping between the two types of builds results in this issue. Just delete the environment file and try again.
