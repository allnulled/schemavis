module.exports = function(grunt) {
	const Paths = require(__dirname + "/bin/modules/paths.js");
	const globby = require("globby");
	const path = require("path");
	const files = globby.sync(Paths.get("bin/grunt.*.js"));
	files.forEach(function(file) {
		const basename = path.basename(file);
		const taskname = basename
			.replace(/^grunt\./g, "")
			.replace(/\.js$/g, "");
		grunt.registerTask(taskname, function() {
			Paths.require(`/bin/${basename}`).call(this, grunt);
		});
	});
};