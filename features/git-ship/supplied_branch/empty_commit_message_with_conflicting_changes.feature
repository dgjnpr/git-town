Feature: cancel shipping a supplied branch by entering an empty commit message with open changes

  Background:
    Given I have feature branches named "feature" and "other_feature"
    And the following commit exists in my repository
      | BRANCH  | LOCATION         | MESSAGE        | FILE NAME    | FILE CONTENT    |
      | main    | local and remote | main commit    | main_file    | main content    |
      | feature | local            | feature commit | feature_file | feature content |
    And I am on the "other_feature" branch
    And I have an uncommitted file with name: "main_file" and content: "conflicting content"
    When I run `git ship feature` and enter an empty commit message


  Scenario: result
    Then it runs the Git commands
      | BRANCH        | COMMAND                            |
      | other_feature | git stash -u                       |
      | other_feature | git checkout main                  |
      | main          | git fetch --prune                  |
      | main          | git rebase origin/main             |
      | main          | git checkout feature               |
      | feature       | git merge --no-edit origin/feature |
      | feature       | git merge --no-edit main           |
      | feature       | git checkout main                  |
      | main          | git merge --squash feature         |
      | main          | git commit -a                      |
      | main          | git reset --hard                   |
      | main          | git checkout feature               |
      | feature       | git checkout main                  |
      | main          | git checkout other_feature         |
      | other_feature | git stash pop                      |
    And I get the error "Aborting ship due to empty commit message"
    And I am still on the "other_feature" branch
    And I still have an uncommitted file with name: "main_file" and content: "conflicting content"
    And I still have the following commits
      | BRANCH  | LOCATION         | MESSAGE                          | FILES        |
      | main    | local and remote | main commit                      | main_file    |
      | feature | local            | feature commit                   | feature_file |
      | feature | local            | Merge branch 'main' into feature |              |
      | feature | local            | main commit                      | main_file    |
    And I still have the following committed files
      | BRANCH  | FILES        | CONTENT         |
      | main    | main_file    | main content    |
      | feature | feature_file | feature content |
      | feature | main_file    | main content    |
