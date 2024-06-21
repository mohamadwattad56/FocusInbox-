import fetch from 'node-fetch';

interface GenerateResponse {
    response: string;
}
// remember to ask pini about the api models ,
async function generateResponse(prompt: string, model: string): Promise<GenerateResponse> {
    const response = await fetch('http://85.130.185.27:11434/api/generate',
        {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            model: model,
            prompt: prompt,
            stream: false,
        }),
    });

    if (!response.ok) {
        throw new Error('Network response was not ok');
    }

    const data = await response.json() as GenerateResponse;
    return data;
}

export { generateResponse };
