Feature: Git Ship: errors when the branch diff is empty

  Background:
    Given I have a feature branch named "empty-feature"
    And the following commit exists in my repository
      | BRANCH        | LOCATION | FILE NAME   | FILE CONTENT   |
      | main          | remote   | common_file | common content |
      | empty-feature | local    | common_file | common content |
    And I am on the "empty-feature" branch
    When I run `git ship` while allowing errors


  Scenario: result
    Then it runs the Git commands
      | BRANCH        | COMMAND                                  |
      | empty-feature | git checkout main                        |
      | main          | git fetch --prune                        |
      | main          | git rebase origin/main                   |
      | main          | git checkout empty-feature               |
      | empty-feature | git merge --no-edit origin/empty-feature |
      | empty-feature | git merge --no-edit main                 |
      | empty-feature | git checkout main                        |
      | main          | git checkout empty-feature               |
    And I get the error "The branch 'empty-feature' has no shippable changes"
    And I am still on the "empty-feature" branch
