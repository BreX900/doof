import Decimal from "decimal.js";
import { firestore } from "firebase-admin";
import Timestamp = firestore.Timestamp;

export interface UserDto {
  readonly id: string;
  readonly email: string;
  readonly displayName: string;
}

export interface PublicUserDto {
  readonly id: string;
  readonly displayName: string;
}

export enum OrderStatus {
  draft = "draft",
  sent = "sent",
}

export interface OrderDto {
  readonly id: string;
  readonly createdAt: Date;
  readonly status: OrderStatus;
}

export interface MatchDto {
  readonly id: string;
  readonly createdAt: Date;
  readonly leftPlayerIds: ReadonlyArray<string>;
  readonly rightPlayerIds: ReadonlyArray<string>;
  readonly leftPoints: number;
  readonly rightPoint: number;
}

export interface ProductDto {
  readonly id: string;
  readonly title: string;
  readonly description: string;
  readonly price: Decimal;
}

export interface AdditionDto {
  readonly id: string;
  readonly productIds: ReadonlyArray<string>;
  readonly title: string;
  readonly description: string;
  readonly price: Decimal;
}

export interface ProductOrderDto {
  readonly id: string;
  readonly buyers: ReadonlyArray<PublicUserDto>;
  readonly product: ProductDto;
  readonly quantity: number;
  readonly additions: ReadonlyArray<AdditionOrderDto>;
  readonly ingredients: ReadonlyArray<IngredientOrderDto>;
}

export interface AdditionOrderDto {
  readonly addition: AdditionDto;
}

export interface IngredientDto {
  readonly id: string;
  readonly productIds: ReadonlyArray<string>;
  readonly title: string;
  readonly description: string;
  readonly minLevel: number;
  readonly maxLevel: number;
}

export interface IngredientOrderDto {
  readonly ingredient: IngredientDto;
  readonly value: number;
}

export abstract class Serializers {
  static serializeUserDto(value: UserDto) {
    return {
      id: value.id,
      email: value.email,
      displayName: value.displayName,
    }
  }

  static serializePublicUserDto(value: PublicUserDto) {
    return {
      id: value.id,
      displayName: value.displayName,
    }
  }

  static serializeOrderDto(value: OrderDto) {
    return {
      id: value.id,
      createdAt: Timestamp.fromDate(value.createdAt),
      status: value.status,
    }
  }

  static serializeMatchDto(value: MatchDto) {
    return {
      id: value.id,
      createdAt: Timestamp.fromDate(value.createdAt),
      leftPlayerIds: value.leftPlayerIds,
      rightPlayerIds: value.rightPlayerIds,
      leftPoints: value.leftPoints,
      rightPoint: value.rightPoint,
    }
  }

  static serializeProductDto(value: ProductDto) {
    return {
      id: value.id,
      title: value.title,
      description: value.description,
      price: value.price,
    }
  }

  static serializeAdditionDto(value: AdditionDto) {
    return {
      id: value.id,
      productIds: value.productIds,
      title: value.title,
      description: value.description,
      price: value.price,
    }
  }

  static serializeProductOrderDto(value: ProductOrderDto) {
    return {
      id: value.id,
      buyers: value.buyers,
      product: value.product,
      quantity: value.quantity,
      additions: value.additions,
      ingredients: value.ingredients,
    }
  }

  static serializeAdditionOrderDto(value: AdditionOrderDto) {
    return {
      addition: value.addition,
    }
  }

  static serializeIngredientDto(value: IngredientDto) {
    return {
      id: value.id,
      productIds: value.productIds,
      title: value.title,
      description: value.description,
      minLevel: value.minLevel,
      maxLevel: value.maxLevel,
    }
  }

  static serializeIngredientOrderDto(value: IngredientOrderDto) {
    return {
      ingredient: value.ingredient,
      value: value.value,
    }
  }
}
