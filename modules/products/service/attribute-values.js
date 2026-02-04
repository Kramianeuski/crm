const valueTypeFields = {
  string: 'value_string',
  number: 'value_number',
  bool: 'value_bool',
  enum: 'value_enum'
};

export function normalizeAttributeValues(values, attributeTypes) {
  const typeMap = new Map(attributeTypes.map(item => [item.id, item.value_type]));

  return values.map(value => {
    const valueType = typeMap.get(value.attribute_id);
    if (!valueType) {
      const error = new Error('attribute_not_found');
      error.statusCode = 422;
      throw error;
    }

    const allowedField = valueTypeFields[valueType];
    if (!allowedField) {
      const error = new Error('attribute_value_type_invalid');
      error.statusCode = 422;
      throw error;
    }

    const payload = {
      attribute_id: value.attribute_id,
      value_string: null,
      value_number: null,
      value_bool: null,
      value_enum: null
    };

    if (Object.prototype.hasOwnProperty.call(value, allowedField)) {
      payload[allowedField] = value[allowedField];
    } else if (value.value !== undefined) {
      payload[allowedField] = value.value;
    }

    return payload;
  });
}
