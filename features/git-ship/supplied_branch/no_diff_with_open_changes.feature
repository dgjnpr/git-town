Feature: Git Ship: errors when the branch diff is empty with open changes

  Background:
    Given I have feature branches named "empty-feature" and "other_feature"
    And the following commit exists in my repository
      | BRANCH        | LOCATION | FILE NAME   | FILE CONTENT   |
      | main          | remote   | common_file | common content |
      | empty-feature | local    | common_file | common content |
    And I am on the "other_feature" branch
    And I have an uncommitted file with name: "uncommitted" and content: "stuff"
    When I run `git ship empty-feature` while allowing errors


  Scenario: result
    Then it runs the Git commands
      | BRANCH        | COMMAND                                  |
      | other_feature | git stash -u                             |
      | other_feature | git checkout main                        |
      | main          | git fetch --prune                        |
      | main          | git rebase origin/main                   |
      | main          | git checkout empty-feature               |
      | empty-feature | git merge --no-edit origin/empty-feature |
      | empty-feature | git merge --no-edit main                 |
      | empty-feature | git checkout main                        |
      | main          | git checkout other_feature               |
      | other_feature | git stash pop                            |
    And I get the error "The branch 'empty-feature' has no shippable changes"
    And I am still on the "other_feature" branch
    And I still have an uncommitted file with name: "uncommitted" and content: "stuff"
