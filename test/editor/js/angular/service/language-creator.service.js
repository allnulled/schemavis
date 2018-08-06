angular
	.module("LanguageCreator", [])
	.service("LanguageCreatorService", function() {
		Object.assign(this, window.LanguageCreatorData.LanguageParser);
	});