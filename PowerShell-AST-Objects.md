---
title: PowerShell AST Objects
---

## Table

| Name                               | BaseObject                |
|------------------------------------|---------------------------|
| CatchClauseAst                     | Ast                       |
| SequencePointAst                   | Ast                       |
| CommandElementAst                  | Ast                       |
| RedirectionAst                     | Ast                       |
| ScriptBlockAst                     | Ast                       |
| ParamBlockAst                      | Ast                       |
| NamedBlockAst                      | Ast                       |
| NamedAttributeArgumentAst          | Ast                       |
| AttributeBaseAst                   | Ast                       |
| ParameterAst                       | Ast                       |
| StatementBlockAst                  | Ast                       |
| StatementAst                       | Ast                       |
| MemberAst                          | Ast                       |
| AttributeAst                       | AttributeBaseAst          |
| TypeConstraintAst                  | AttributeBaseAst          |
| ConvertExpressionAst               | AttributedExpressionAst   |
| PipelineAst                        | ChainableAst              |
| PipelineChainAst                   | ChainableAst              |
| CommandExpressionAst               | CommandBaseAst            |
| CommandAst                         | CommandBaseAst            |
| ExpressionAst                      | CommandElementAst         |
| CommandParameterAst                | CommandElementAst         |
| StringConstantExpressionAst        | ConstantExpressionAst     |
| AttributedExpressionAst            | ExpressionAst             |
| MemberExpressionAst                | ExpressionAst             |
| TernaryExpressionAst               | ExpressionAst             |
| IndexExpressionAst                 | ExpressionAst             |
| SubExpressionAst                   | ExpressionAst             |
| TypeExpressionAst                  | ExpressionAst             |
| VariableExpressionAst              | ExpressionAst             |
| ConstantExpressionAst              | ExpressionAst             |
| UsingExpressionAst                 | ExpressionAst             |
| UnaryExpressionAst                 | ExpressionAst             |
| HashtableAst                       | ExpressionAst             |
| BinaryExpressionAst                | ExpressionAst             |
| ErrorExpressionAst                 | ExpressionAst             |
| ParenExpressionAst                 | ExpressionAst             |
| ArrayExpressionAst                 | ExpressionAst             |
| ArrayLiteralAst                    | ExpressionAst             |
| ExpandableStringExpressionAst      | ExpressionAst             |
| ScriptBlockExpressionAst           | ExpressionAst             |
| BaseCtorInvokeMemberExpressionAst  | InvokeMemberExpressionAst |
| SwitchStatementAst                 | LabeledStatementAst       |
| LoopStatementAst                   | LabeledStatementAst       |
| WhileStatementAst                  | LoopStatementAst          |
| ForEachStatementAst                | LoopStatementAst          |
| ForStatementAst                    | LoopStatementAst          |
| DoWhileStatementAst                | LoopStatementAst          |
| DoUntilStatementAst                | LoopStatementAst          |
| CompilerGeneratedMemberFunctionAst | MemberAst                 |
| FunctionMemberAst                  | MemberAst                 |
| PropertyMemberAst                  | MemberAst                 |
| InvokeMemberExpressionAst          | MemberExpressionAst       |
| ChainableAst                       | PipelineBaseAst           |
| AssignmentStatementAst             | PipelineBaseAst           |
| ErrorStatementAst                  | PipelineBaseAst           |
| MergingRedirectionAst              | RedirectionAst            |
| FileRedirectionAst                 | RedirectionAst            |
| ExitStatementAst                   | StatementAst              |
| DynamicKeywordStatementAst         | StatementAst              |
| TypeDefinitionAst                  | StatementAst              |
| UsingStatementAst                  | StatementAst              |
| FunctionDefinitionAst              | StatementAst              |
| IfStatementAst                     | StatementAst              |
| DataStatementAst                   | StatementAst              |
| LabeledStatementAst                | StatementAst              |
| BlockStatementAst                  | StatementAst              |
| TryStatementAst                    | StatementAst              |
| BreakStatementAst                  | StatementAst              |
| ContinueStatementAst               | StatementAst              |
| ReturnStatementAst                 | StatementAst              |
| PipelineBaseAst                    | StatementAst              |
| CommandBaseAst                     | StatementAst              |
| ConfigurationDefinitionAst         | StatementAst              |
| TrapStatementAst                   | StatementAst              |
| ThrowStatementAst                  | StatementAst              |
| Ast                                | System.Object             |
| ConvertViaCast                     | System.Object             |

## Tree

```
──System.Object
  └─Ast
    ├─CatchClauseAst
    ├─SequencePointAst
    ├─CommandElementAst
    │ ├─ExpressionAst
    │ │ ├─AttributedExpressionAst
    │ │ │ └─ConvertExpressionAst
    │ │ ├─MemberExpressionAst
    │ │ │ └─InvokeMemberExpressionAst
    │ │ │   └─BaseCtorInvokeMemberExpressionAst
    │ │ ├─TernaryExpressionAst
    │ │ ├─IndexExpressionAst
    │ │ ├─SubExpressionAst
    │ │ ├─TypeExpressionAst
    │ │ ├─VariableExpressionAst
    │ │ ├─ConstantExpressionAst
    │ │ │ └─StringConstantExpressionAst
    │ │ ├─UsingExpressionAst
    │ │ ├─UnaryExpressionAst
    │ │ │ └─HashtableAst
    │ │ ├─BinaryExpressionAst
    │ │ ├─ErrorExpressionAst
    │ │ ├─ParenExpressionAst
    │ │ ├─ArrayExpressionAst
    │ │ ├─ArrayLiteralAst
    │ │ ├─ExpandableStringExpressionAst
    │ │ └─ScriptBlockExpressionAst
    │ └─CommandParameterAst
    ├─RedirectionAst
    │  ├─MergingRedirectionAst
    │  └─FileRedirectionAst
    ├─ScriptBlockAst
    ├─ParamBlockAst
    ├─NamedBlockAst
    ├─NamedAttributeArgumentAst
    ├─AttributeBaseAst
    │ ├─AttributeAst
    │ └─TypeConstraintAst
    ├─ParameterAst
    ├─StatementBlockAst
    ├─StatementAst
    │ ├─ExitStatementAst
    │ ├─DynamicKeywordStatementAst
    │ ├─TypeDefinitionAst
    │ ├─UsingStatementAst
    │ ├─FunctionDefinitionAst
    │ ├─IfStatementAst
    │ ├─DataStatementAst
    │ ├─LabeledStatementAst
    │ │ ├─SwitchStatementAst
    │ │ └─LoopStatementAst
    │ │   ├─WhileStatementAst
    │ │   ├─ForEachStatementAst
    │ │   ├─ForStatementAst
    │ │   ├─DoWhileStatementAst
    │ │   └─DoUntilStatementAst
    │ ├─BlockStatementAst
    │ ├─TryStatementAst
    │ ├─BreakStatementAst
    │ ├─ContinueStatementAst
    │ ├─ReturnStatementAst
    │ ├─PipelineBaseAst
    │ │ ├─ChainableAst
    │ │ │ ├─PipelineAst
    │ │ │ └─PipelineChainAst
    │ │ ├─AssignmentStatementAst
    │ │ └─ErrorStatementAst
    │ ├─CommandBaseAst
    │ │ ├─CommandExpressionAst
    │ │ └─CommandAst
    │ ├─ConfigurationDefinitionAst
    │ ├─TrapStatementAst
    │ └─ThrowStatementAst
    └─MemberAst
      ├─CompilerGeneratedMemberFunctionAst
      ├─FunctionMemberAst
      └─PropertyMemberAst
```
