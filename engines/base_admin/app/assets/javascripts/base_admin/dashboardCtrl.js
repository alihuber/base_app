(function() {
  angular
  .module('baseApp')
    .controller('dashboardCtrl', ['$scope', '$http', function($scope, $http) {
      $scope.editMode    = false;
      $scope.messageMode = null;

      var init = function () {
        $http.get("/users",
          {"headers": {"Authorization": window.localStorage["session-token"]}})
          .then(function(result) {
            $scope.users = result.data;
        });
      };

      $scope.saveUser = function(user) {
        var req = {
          method: 'PUT',
          url: '/user/id/' + user.id,
          headers: {
            "Authorization": window.localStorage["session-token"]
          },
          data: {"email": user.email, "password": "", "password_confirmation": ""},
        };

        $http(req)
          .then(function(result) {
            $scope.messageMode = ["success", "User successfully saved"];
          }, function(err) {
            $scope.messageMode = ["danger", "User could not be saved"];
          });
      };

      $scope.createUser = function() {
        var req = {
          method: 'POST',
          url: '/users',
          headers: {
            "Authorization": window.localStorage["session-token"]
          },
          data: {"email": $scope.newUser.email, "password": $scope.newUser.password}
        };

        $http(req)
          .then(function(result) {
            $scope.messageMode = ["success", "User successfully created"];
            $scope.newUser = null;
            init();
          }, function(err) {
            $scope.messageMode = ["danger", "User could not be created"];
          });
      };

      $scope.alertClass = function() {
        if($scope.messageMode[0] === "success") {
          return "alert alert-dismissable alert-success";
        } else {
          return "alert alert-dismissable alert-danger";
        }
      };

      $scope.deleteUser = function(id) {
        var req = {
          method: 'DELETE',
          url: '/user/id/' + id,
          headers: {
            "Authorization": window.localStorage["session-token"]
          }
        };

        $http(req)
          .then(function(result) {
            $scope.messageMode = ["success", "User successfully deleted"];
            init();
          }, function(err) {
            $scope.messageMode = ["danger", "User could not be deleted"];
          });
      };

      $scope.newUser = function() {
        $scope.newUser = {"email":"","password": ""};
      };

      $scope.dismiss = function() { $scope.newUser = null; };

      $scope.dismissMessage = function() { $scope.messageMode = null; };

      $scope.toggleEditMode = function() { $scope.editMode = !$scope.editMode; };

      init();
    }]);
})();

