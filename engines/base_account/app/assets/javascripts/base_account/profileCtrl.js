(function() {
  angular
  .module('baseApp')
    .controller('profileCtrl', ['$scope', function($scope) {

      $('#passwordConfirmationInput').tooltip({'placement': 'right',
        'trigger':'manual'});

      $scope.notSamePasswords = function() {
        if(this.new_password !== this.password_confirmation) {
          $('#passwordConfirmationInput').tooltip('show');
          return true;
        } else {
          $('#passwordConfirmationInput').tooltip('hide');
          return false;
        }
      };

      $scope.emailSet = function() {
        console.log(this.email !== undefined);
        return this.email !== undefined && this.email.length !== 0;
      };

      $scope.noFieldsSet = function() {
        return !$scope.emailSet() && $scope.passwordsEmpty();
      };

      $scope.passwordsEmpty = function() {
        if(this.new_password && this.password_confirmation) {
          return this.new_password.length === 0 &&
            this.password_confirmation.length === 0;
        }
        return true;
      };

    }]);
})();
