func tagCommand() *cli.Command {
	directoryArg := "directory"
	tagArg := "tags"
	skipTagsArg := "skip-tags"
	customTaggingArg := "custom-tagging"
	skipDirsArg := "skip-dirs"
	outputArg := "output"
	tagGroupArg := "tag-groups"
	outputJSONFileArg := "output-json-file"
	externalConfPath := "config-file"
	skipResourceTypesArg := "skip-resource-types"
	skipResourcesArg := "skip-resources"
	parsersArgs := "parsers"
	dryRunArgs := "dry-run"
	validateModeArgs := "validate"
	tagLocalModules := "tag-local-modules"
	tagPrefix := "tag-prefix"
	noColor := "no-color"
	useCodeowners := "use-code-owners"
	return &cli.Command{
		Name:                   "tag",
		Usage:                  "apply tagging across your directory",
		HideHelpCommand:        true,
		UseShortOptionHandling: true,
		Action: func(c *cli.Context) error {
			options := clioptions.TagOptions{
				Directory:         c.String(directoryArg),
				Tag:               c.StringSlice(tagArg),
				SkipTags:          c.StringSlice(skipTagsArg),
				CustomTagging:     c.StringSlice(customTaggingArg),
				SkipDirs:          c.StringSlice(skipDirsArg),
				Output:            c.String(outputArg),
				OutputJSONFile:    c.String(outputJSONFileArg),
				TagGroups:         c.StringSlice(tagGroupArg),
				ConfigFile:        c.String(externalConfPath),
				SkipResourceTypes: c.StringSlice(skipResourceTypesArg),
				SkipResources:     c.StringSlice(skipResourcesArg),
				Parsers:           c.StringSlice(parsersArgs),
				DryRun:            c.Bool(dryRunArgs),
				ValidateMode:      c.Bool(validateModeArgs),
				TagLocalModules:   c.Bool(tagLocalModules),
				TagPrefix:         c.String(tagPrefix),
				NoColor:           c.Bool(noColor),
				UseCodeOwners:     c.Bool(useCodeowners),
			}

			options.Validate()

			colors := common.NoColorCheck(options.NoColor)
			return tag(&options, colors)
		},
		Flags: []cli.Flag{ // When adding flags, make sure they are supported in the GitHub action as well via entrypoint.sh
			&cli.StringFlag{
				Name:        directoryArg,
				Aliases:     []string{"d"},
				Usage:       "directory to tag",
				Required:    true,
				DefaultText: "path/to/iac/root",
			},
			&cli.StringSliceFlag{
				Name:        tagArg,
				Aliases:     []string{"t"},
				Usage:       "run yor only with the specified tags",
				DefaultText: "yor_trace,git_repository",
			},
			&cli.StringSliceFlag{
				Name:        skipTagsArg,
				Aliases:     []string{"s"},
				Usage:       "run yor skipping the specified tags",
				Value:       cli.NewStringSlice(),
				DefaultText: "yor_trace",
			},
			&cli.StringFlag{
				Name:        outputArg,
				Aliases:     []string{"o"},
				Usage:       "set output format",
				Value:       "cli",
				DefaultText: "json",
			},
			&cli.StringFlag{
				Name:        outputJSONFileArg,
				Usage:       "json file path for output",
				DefaultText: "result.json",
			},
			&cli.StringSliceFlag{
				Name:        customTaggingArg,
				Aliases:     []string{"c"},
				Usage:       "paths to custom tag groups and tags plugins",
				Value:       cli.NewStringSlice(),
				DefaultText: "path/to/custom/yor/tagging",
			},
			&cli.StringSliceFlag{
				Name:        skipDirsArg,
				Aliases:     nil,
				Usage:       "configuration paths to skip",
				Value:       cli.NewStringSlice(),
				DefaultText: "path/to/skip,another/path/to/skip",
			},
			&cli.StringSliceFlag{
				Name:        tagGroupArg,
				Aliases:     []string{"g"},
				Usage:       "Narrow down results to the matching tag groups",
				Value:       cli.NewStringSlice(utils.GetAllTagGroupsNames()...),
				DefaultText: "git,code2cloud",
			},
			&cli.StringFlag{
				Name:        externalConfPath,
				Usage:       "external tag group configuration file path",
				DefaultText: "/path/to/conf/file/ (.yml/.yaml extension)",
			},
			&cli.StringSliceFlag{
				Name:        skipResourceTypesArg,
				Usage:       "skip resource types for tagging",
				Value:       cli.NewStringSlice(),
				DefaultText: "aws_rds_instance,AWS::S3::Bucket",
			},
			&cli.StringSliceFlag{
				Name:        skipResourcesArg,
				Usage:       "skip resources for tagging",
				Value:       cli.NewStringSlice(),
				DefaultText: "aws_s3_bucket.test-bucket,EC2InstanceResource0",
			},
			&cli.StringSliceFlag{
				Name:        parsersArgs,
				Aliases:     []string{"i"},
				Usage:       "IAC types to tag",
				Value:       cli.NewStringSlice("Terraform", "CloudFormation", "Serverless"),
				DefaultText: "Terraform,CloudFormation,Serverless",
			},
			&cli.BoolFlag{
				Name:        dryRunArgs,
				Usage:       "skip resource tagging",
				Value:       false,
				DefaultText: "false",
			},
			&cli.BoolFlag{
				Name:        validateModeArgs,
				Usage:       "dry-run and exit with error if changes made/needed",
				Value:       false,
				DefaultText: "false",
			},
			&cli.BoolFlag{
				Name:        tagLocalModules,
				Usage:       "Always tag local modules",
				Value:       false,
				DefaultText: "false",
			},
			&cli.StringFlag{
				Name:        tagPrefix,
				Usage:       "Add prefix to all the tags",
				DefaultText: "",
			},
			&cli.BoolFlag{
				Name:        noColor,
				Usage:       "remove colorized output",
				Value:       false,
				DefaultText: "false",
			},
			&cli.BoolFlag{
				Name:        useCodeowners,
				Usage:       "use code owners file to tag team",
				Value:       false,
				DefaultText: "false",
			},
		},
	}
}
