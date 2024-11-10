class PromptExample {
  PromptExample({required this.name, required this.prompt});
  final String name;
  final String prompt;
}

final List<PromptExample> promptExamples = [
  PromptExample(
    name: 'App scaffold',
    prompt:
        "Scaffold application with placeholder for title and three menu items: 'Dashboard', 'Settings', 'Help' and 'About'",
  ),
  PromptExample(
    name: 'App theme',
    prompt: '''
Define a theme for the app and create a widget that shows how basic widgets look with the theme applied.
The theme should target children of age 6 to 12, with a playful and colorful design.

Use a bright color palette.
The primary color should be a vibrant shade of blue, while the secondary color should be a warm yellow.
Use contrasting colors for text and background to ensure readability.
The font style should be a fun, friendly and easy to read.
Buttons should have rounded corners and a subtle shadow effect when pressed.
Text fields should have a light gray border and a hint text color that matches the primary color.
Headings should be bold and slightly larger than body text, with a color that complements the primary color.
The widget should display a preview of the theme with examples of buttons,
text fields, and headings styled according to the theme. The preview should be interactive,
allowing users to see how the colors and sizes change with selections.

 The design should be visually appealing and engaging for children, encouraging them to explore and interact with the app.''',
  ),
  PromptExample(
    name: 'Editable list',
    prompt:
        'Show list of items, where user can add, remove, and edit the items.',
  ),
  PromptExample(
    name: 'Ask for rate',
    prompt:
        'Ask user to rate the experience from 1 to 5 stars, to provide optional details, and to submit the feedback.',
  ),
  PromptExample(
    name: 'Math quest',
    prompt:
        'Show user two random numbers, ask user to sum them and verify the result.',
  ),
  PromptExample(
    name: 'Contact search',
    prompt:
        r"""Create a UI for a contact search input field that accepts only phone number input.
It should trigger a search on input change, with the search results displayed below it.
Position the input field at the top of the screen with a white background and a subtle border.
Use a standard system font with regular weight for the input field.
The search results UI should be visible only when search results are non-empty. Organize the results into two
sections: "People" and "Businesses." Display the title of each section in a slightly bolder font weight.
In the "People" section, show a list of people contacts. Represent each contact with a circle containing the
first letter of their name. Next to each initial, display the contact's full name and phone number.
The "Businesses" section displays business contacts using a similar list-like structure but with a different
icon and information. Each business entry should include a circle with the first letter of the business name.
Below the icon, display the business name and a brief description in a smaller font size.
The getContacts method of the ContactService class will source the contact data.
It already exists and will be added later.
Do not reimplement ContactService. When the user enters a phone number in the input field,
the UI should send the input to the getContacts method of the ContactService to retrieve the relevant contacts.
Then the UI should display it in search result section. The getContacts method returns a Future with a Map-based
 data structure that adheres to the following JSON schema:
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "Contacts Data",
  "description": "Schema for a contact search results.",
  "type": "object",
  "properties": {
    "contacts": {
      "type": "array",
      "properties": {
        "contact": {
          "type": "object",
          "properties": {
            "name": {
              "type": "string"
            },
            "phoneNumber": {
              "type": "string"
            },
            "contactType": {
              "enum": [
                "people",
                "business"
              ]
            }
          },
          "required": [
            "name",
            "phoneNumber",
            "contactType"
          ]
        }
      }
    }
  }
}

The UI background is white, providing a clean backdrop for the content. Text colors should be dark gray
for headings and labels, and black for body text and phone numbers. The font style is a standard system
font, using regular weight for body text and a slightly bolder weight for headings. Icons should be dark
gray or black, maintaining a consistent size and style. Ensure sufficient padding and spacing between
sections and UI elements to enhance readability and visual hierarchy. The overall design should be simple
and easy to navigate, with a focus on a clean and organized presentation of phone numbers and contacts.
""",
  ),
];
