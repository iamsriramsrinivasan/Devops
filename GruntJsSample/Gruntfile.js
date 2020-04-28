module.exports = function(grunt) {
  //Configuration

  grunt.initConfig({
    //What plugins and references to be added

    concat: {
      js: {
        src: ["js/*.js"],
        dest: "build/scripts.js"
      },
      css: {
        src: ["css/reset.css", "css/bootstrap.css", "css/styles.css"],
        dest: "build/styles.css"
      }
    },
    uglify: {
      build: {
        files: [
          {
            src: "build/scripts.js",
            dest: "build/scripts.js"
          }
        ]
      }
    }
  });

  //load plugins

  grunt.loadNpmTasks("grunt-contrib-concat");
  grunt.loadNpmTasks("grunt-contrib-uglify");

  //Register tasks

  grunt.registerTask("concat-js", ["concat:js"]);

  grunt.registerTask("concat-css", ["concat:css"]);
};
