# Diagramas de Sistema - Business Budget

## 🏗️ Diagrama de Arquitetura Geral

```mermaid
graph TD
    A[Flutter App] --> B[BLoC Pattern]
    B --> C[Business Layer]
    B --> D[Presentation Layer]
    
    C --> E[Rules Engine]
    C --> F[Factory Service]
    C --> G[Repository Layer]
    C --> H[Strategy Patterns]
    
    E --> E1[Condition Evaluator]
    E --> E2[Action Executor]
    E --> E3[Priority Manager]
    
    F --> F1[Product Factory]
    F --> F2[Field Factory]
    
    G --> G1[IRepository<T>]
    G --> G2[InMemoryRepository<T>]
    G --> G3[ProductRepository]
    
    H --> H1[Pricing Strategy]
    H --> H2[Validation Strategy]
    H --> H3[Rendering Strategy]
    
    D --> D1[Dynamic Form Widget]
    D --> D2[Quote Page]
    D --> D3[Components]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8f5e8
    style D fill:#fff3e0
```

## 🔄 Fluxo de Estados BLoC

```mermaid
stateDiagram-v2
    [*] --> InitialState
    
    InitialState --> ProductSelected : SelectProduct
    ProductSelected --> FormUpdated : FieldChanged
    FormUpdated --> FormUpdated : FieldChanged
    FormUpdated --> Calculating : CalculatePrice
    Calculating --> FormUpdated : PriceCalculated
    FormUpdated --> Validated : ValidateForm
    Validated --> FormUpdated : ValidationComplete
    
    note right of FormUpdated
        - Dynamic Fields
        - Real-time Validation
        - Price Updates
        - Rule Processing
    end note
    
    note right of Calculating
        - Volume Discount
        - Urgency Fee
        - Business Rules
        - Final Price
    end note
```

## 🏭 Hierarquia de Classes de Produto

```mermaid
classDiagram
    class Product {
        <<abstract>>
        +String name
        +double price
        +int quantity
        +int deadline
        +Product(name, price, quantity, deadline)
    }
    
    class IndustrialProduct {
        +int voltage
        +String certification
        +int industrialCapacity
        +IndustrialProduct(...)
    }
    
    class ResidentialProduct {
        +String color
        +String guarantee
        +String finishing
        +ResidentialProduct(...)
    }
    
    class CorporateProduct {
        +int corporateVolume
        +String contract
        +String sla
        +CorporateProduct(...)
    }
    
    Product <|-- IndustrialProduct
    Product <|-- ResidentialProduct
    Product <|-- CorporateProduct
    
    class BusinessRule {
        <<abstract>>
        +bool apply(Product product)
    }
    
    class PricingRule {
        +double calculateFinalPrice(Product)
    }
    
    class ValidationRule {
        +String getCertificationMessage(Product)
    }
    
    class VisibilityRule {
        +List~FormFieldModel~ getFieldsForProductType(String)
    }
    
    BusinessRule <|-- PricingRule
    BusinessRule <|-- ValidationRule
    BusinessRule <|-- VisibilityRule
```

## 🎯 Padrão Strategy

```mermaid
classDiagram
    class IPricingStrategy {
        <<interface>>
        +double calculatePrice(Product product)
    }
    
    class IValidationStrategy {
        <<interface>>
        +bool validate(Product product)
        +String getValidationMessage(Product product)
    }
    
    class IRenderingStrategy {
        <<interface>>
        +List~FormFieldModel~ getFields(String productType)
    }
    
    class IndustrialPricingStrategy {
        +double calculatePrice(Product product)
    }
    
    class ResidentialPricingStrategy {
        +double calculatePrice(Product product)
    }
    
    class CorporatePricingStrategy {
        +double calculatePrice(Product product)
    }
    
    class IndustrialValidationStrategy {
        +bool validate(Product product)
        +String getValidationMessage(Product product)
    }
    
    class ResidentialValidationStrategy {
        +bool validate(Product product)
        +String getValidationMessage(Product product)
    }
    
    class CorporateValidationStrategy {
        +bool validate(Product product)
        +String getValidationMessage(Product product)
    }
    
    IPricingStrategy <|.. IndustrialPricingStrategy
    IPricingStrategy <|.. ResidentialPricingStrategy
    IPricingStrategy <|.. CorporatePricingStrategy
    
    IValidationStrategy <|.. IndustrialValidationStrategy
    IValidationStrategy <|.. ResidentialValidationStrategy
    IValidationStrategy <|.. CorporateValidationStrategy
    
    class BusinessBloc {
        -Map~String, IPricingStrategy~ pricingStrategies
        -Map~String, IValidationStrategy~ validationStrategies
        +void _onFieldChanged(event, emit)
    }
    
    BusinessBloc --> IPricingStrategy
    BusinessBloc --> IValidationStrategy
```

## 🛠️ Repository Pattern Genérico

```mermaid
classDiagram
    class BaseModel {
        <<abstract>>
        +String id
        +DateTime createdAt
        +DateTime updatedAt
    }
    
    class IRepository~T~ {
        <<interface>>
        +Future~T?~ findById(String id)
        +Future~List~T~~ findAll()
        +Future~T~ save(T entity)
        +Future~bool~ deleteById(String id)
    }
    
    class InMemoryRepository~T~ {
        <<abstract>>
        -Map~String, T~ _storage
        +Future~T?~ findById(String id)
        +Future~List~T~~ findAll()
        +Future~T~ save(T entity)
        +Future~bool~ deleteById(String id)
    }
    
    class ProductRepository {
        +Future~List~ProductModel~~ findByType(String type)
        +Future~List~ProductModel~~ findUrgentProducts()
        +Future~ProductModel~ save(ProductModel product)
    }
    
    class ProductModel {
        +String id
        +String name
        +String type
        +double price
        +Map~String, dynamic~ specificFields
    }
    
    BaseModel <|-- ProductModel
    IRepository <|.. InMemoryRepository
    InMemoryRepository <|-- ProductRepository
    ProductRepository --> ProductModel
    
    note for IRepository "T extends BaseModel\nType-safe operations"
    note for InMemoryRepository "Generic implementation\nMemory-based storage"
    note for ProductRepository "Concrete specialization\nProduct-specific queries"
```

## ⚙️ Rules Engine com Composição

```mermaid
graph TB
    A[RulesEngine&lt;T extends Product&gt;] --> B[ConditionEvaluator]
    A --> C[ActionExecutor] 
    A --> D[PriorityManager]
    A --> E[Rule Repository]
    
    B --> B1[evaluate(condition, product)]
    B --> B2[evaluateComplex(conditions)]
    
    C --> C1[execute(action, product)]
    C --> C2[executeMultiple(actions)]
    
    D --> D1[sortByPriority(rules)]
    D --> D2[resolveConflicts(results)]
    
    E --> E1[Volume Discount Rules]
    E --> E2[Urgency Fee Rules]
    E --> E3[Certification Rules]
    E --> E4[Validation Rules]
    
    F[BusinessBloc] --> A
    
    G[Product Input] --> A
    A --> H[Processing Result]
    
    H --> H1[Price Adjustments]
    H --> H2[Validation Messages]
    H --> H3[Field Visibility]
    H --> H4[Business Warnings]
    
    style A fill:#e3f2fd
    style F fill:#f3e5f5
    style G fill:#e8f5e8
    style H fill:#fff8e1
```

## 🔄 Fluxo de Processamento de Formulário

```mermaid
sequenceDiagram
    participant UI as User Interface
    participant Bloc as BusinessBloc
    participant Factory as ProductFactory
    participant Rules as RulesEngine
    participant Strategy as ValidationStrategy
    participant Calc as CalculatorMixin
    
    UI->>Bloc: SelectProduct(type)
    Bloc->>UI: emit ProductSelected + Dynamic Fields
    
    UI->>Bloc: FieldChanged(field, value)
    Bloc->>Factory: createProduct(allFields, type)
    Factory-->>Bloc: Product instance
    
    Bloc->>Strategy: validate(product)
    Strategy-->>Bloc: validation result + message
    
    Bloc->>Rules: processRules(product)
    Rules-->>Bloc: rules result + adjustments
    
    Bloc->>Calc: calculateFinalPrice(params)
    Calc-->>Bloc: final price
    
    Bloc->>UI: emit FormUpdated(fields, price, validation)
    
    Note over UI,Calc: Real-time updates on every field change
```

## 📱 Estrutura de Componentes UI

```mermaid
graph TD
    A[QuotePage] --> B[DynamicFormWidget]
    
    B --> C[Product Type Dropdown]
    B --> D[Dynamic Fields Container]
    B --> E[Price Display]
    B --> F[Validation Messages]
    
    D --> G[Text Fields]
    D --> H[Number Fields]
    D --> I[Dropdown Fields]
    
    G --> G1[TextFieldModel]
    H --> H1[DoubleFieldModel]
    H --> H2[IntFieldModel]
    I --> I1[DropdownFormComponent]
    
    E --> E1[Base Price]
    E --> E2[Discounts]
    E --> E3[Fees]
    E --> E4[Final Price]
    
    F --> F1[Field Validation]
    F --> F2[Business Rules]
    F --> F3[Certification Alerts]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style D fill:#e8f5e8
    style E fill:#fff3e0
    style F fill:#ffebee
```

## 🎭 Mixins e Extensions

```mermaid
classDiagram
    class CalculatorMixin {
        <<mixin>>
        +double calculateVolumeDiscount(quantity, price)
        +double calculateUrgencyFee(deadline, price)
        +double calculateFinalPrice(params)
    }
    
    class ValidatorMixin {
        <<mixin>>
        +bool isInRange(value, min, max)
        +bool isRequired(value)
        +bool isPositive(value)
    }
    
    class FormatterMixin {
        <<mixin>>
        +String formatCurrency(value)
        +String formatNumber(value)
    }
    
    class ProductExtensions {
        <<extension on Product>>
        +bool get needsCertification
        +bool get hasVolumeDiscount
        +bool get isHighPriority
    }
    
    class StringExtensions {
        <<extension on String>>
        +double toDoubleValue()
        +int toIntValue()
        +bool get isNumeric
    }
    
    class BusinessBloc {
        +_onProductSelected()
        +_onFieldChanged()
        +_calculatePrice()
    }
    
    BusinessBloc ..|> CalculatorMixin : uses
    BusinessBloc ..|> ValidatorMixin : uses
    BusinessBloc ..|> FormatterMixin : uses
    
    note for CalculatorMixin "Reusable calculation logic"
    note for ValidatorMixin "Common validation patterns"
    note for FormatterMixin "Display formatting utilities"
    note for ProductExtensions "Product-specific behaviors"
    note for StringExtensions "String parsing utilities"
```

## 🔐 Type Safety e Constraints

```mermaid
graph LR
    A[Generic Types] --> B[IRepository&lt;T extends BaseModel&gt;]
    A --> C[RulesEngine&lt;T extends Product&gt;]
    A --> D[FactoryService&lt;T&gt;]
    
    B --> B1[Compile-time Safety]
    B --> B2[IDE IntelliSense]
    B --> B3[Refactoring Support]
    
    C --> C1[Product Type Bounds]
    C --> C2[Rule Type Safety]
    C --> C3[Result Type Consistency]
    
    D --> D1[Factory Pattern]
    D --> D2[Type-safe Creation]
    D --> D3[Polymorphic Returns]
    
    E[Runtime Benefits] --> E1[No Type Casting]
    E --> E2[Reduced Bugs]
    E --> E3[Better Performance]
    
    style A fill:#e3f2fd
    style E fill:#e8f5e8
    style B1 fill:#c8e6c9
    style C1 fill:#c8e6c9
    style D1 fill:#c8e6c9
```

---

*Estes diagramas ilustram a arquitetura robusta e escalável do Business Budget, demonstrando como os padrões de design, genéricos e princípios SOLID trabalham juntos para criar um sistema maintível e extensível.*
