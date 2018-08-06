angular
  .module("networkVisualizer", [])
  .directive("networkVisualizer", [function() {
    return {
      restrict: "EA",
      scope: {
        networkModel: "="
      },
      transclude: true,
      link: function($scope, $element, $attributes) {
        $element[0].innerHTML = "Hola";
        //console.log($scope);
        $scope.$watch("networkModel", function(newValue, oldValue) {
          const {nodes, edges, options} = JSON.parse(newValue);
          $scope.networkElement = new vis.Network($element[0], {nodes, edges}, options);
        });
        window.$scope = $scope;
      }
    }
  }]);